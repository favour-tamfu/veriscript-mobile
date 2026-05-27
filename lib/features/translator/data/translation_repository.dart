import 'package:flutter_riverpod/flutter_riverpod.dart';
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
