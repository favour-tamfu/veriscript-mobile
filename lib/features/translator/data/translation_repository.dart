import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/local_db/app_database.dart';
import '../../../core/network/edge_function_caller.dart';
import '../../../core/supabase/supabase_providers.dart';

final translationRepositoryProvider = Provider<TranslationRepository>(
  (ref) => TranslationRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(edgeFunctionCallerProvider),
    ref.watch(translationsDaoProvider),
  ),
);

class TranslationResult {
  const TranslationResult({
    required this.translatedText,
    required this.detectedSourceLang,
    required this.charCount,
    this.fromCache = false,
  });

  final String translatedText;
  final String? detectedSourceLang;
  final int charCount;
  final bool fromCache;
}

/// Result of a layout-preserving document translation. [outputPath] points at
/// the translated file in the `processed` bucket.
class DocumentTranslationResult {
  const DocumentTranslationResult({
    required this.outputPath,
    required this.outputName,
    this.detectedSourceLang,
    this.mimeType,
  });

  final String outputPath;
  final String outputName;
  final String? detectedSourceLang;
  final String? mimeType;
}

/// Document formats accepted for translation (matches the edge function).
const kTranslatableDocExtensions = ['pdf', 'docx', 'pptx', 'xlsx', 'txt'];

class TranslationRepository {
  TranslationRepository(this._client, this._edgeFunctionCaller, this._translationsDao);

  final SupabaseClient _client;
  final EdgeFunctionCaller _edgeFunctionCaller;
  final TranslationsDao _translationsDao;

  Future<TranslationResult?> getCachedTranslation(
    String userId,
    String text,
    String source,
    String target,
  ) async {
    final row = await _translationsDao.findCached(userId, text, source, target);
    if (row == null) return null;
    return TranslationResult(
      translatedText: row.outputText,
      detectedSourceLang: row.sourceLang,
      charCount: text.length,
      fromCache: true,
    );
  }

  Future<TranslationResult> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
    required String userId,
    String? documentId,
  }) async {
    // Check cache first
    final cached = await getCachedTranslation(userId, text, sourceLang, targetLang);
    if (cached != null) return cached;

    final result = await _edgeFunctionCaller.invoke('translate-text', body: {
      'text': text,
      'sourceLang': sourceLang,
      'targetLang': targetLang,
      'userId': userId,
      if (documentId != null) 'documentId': documentId,
    });

    return TranslationResult(
      translatedText: result['translatedText'] as String,
      detectedSourceLang: result['detectedSourceLang'] as String?,
      charCount: result['charCount'] as int? ?? text.length,
    );
  }

  /// Uploads [file] to the `documents` bucket and returns its storage path.
  Future<String> uploadDocument(File file, String userId) async {
    final fileName = p.basename(file.path);
    final storagePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await _client.storage.from('documents').upload(
          storagePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    return storagePath;
  }

  /// Calls the `translate-document` edge function for a layout-preserving
  /// translation. The translated file lands in the `processed` bucket.
  Future<DocumentTranslationResult> translateDocument({
    required String storagePath,
    required String fileName,
    required String sourceLang,
    required String targetLang,
    required String userId,
  }) async {
    final result = await _edgeFunctionCaller.invoke('translate-document', body: {
      'storagePath': storagePath,
      'fileName': fileName,
      'sourceLang': sourceLang,
      'targetLang': targetLang,
      'userId': userId,
    });

    return DocumentTranslationResult(
      outputPath: result['outputPath'] as String,
      outputName: result['outputName'] as String? ?? fileName,
      detectedSourceLang: result['detectedSourceLang'] as String?,
      mimeType: result['mimeType'] as String?,
    );
  }

  /// Signed URL for downloading a translated document from `processed`.
  Future<String> getTranslatedDocUrl(String outputPath) async {
    return _client.storage.from('processed').createSignedUrl(outputPath, 60 * 60);
  }

  Future<void> updateCharCount(String userId, int charCount) async {
    await _client.rpc('increment_chars_translated', params: {
      'p_user_id': userId,
      'p_chars': charCount,
    });
  }

  Future<bool> canTranslate(String userId, int textLength) async {
    final data = await _client
        .from('usage_quotas')
        .select('chars_translated')
        .eq('user_id', userId)
        .maybeSingle();

    final profile = await _client
        .from('profiles')
        .select('plan')
        .eq('id', userId)
        .maybeSingle();

    final charsUsed = (data?['chars_translated'] as int?) ?? 0;
    final isPlusUser = profile?['plan'] == 'plus';

    if (isPlusUser) return true;
    return charsUsed + textLength <= 5000;
  }
}
