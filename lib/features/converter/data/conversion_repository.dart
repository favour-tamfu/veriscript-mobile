import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';

/// Free monthly conversions for non-Plus users.
const int kFreeConversionLimit = 5;

final conversionRepositoryProvider = Provider<ConversionRepository>(
  (ref) => ConversionRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseStorageProvider),
  ),
);

class ConversionRepository {
  ConversionRepository(this._client, this._storage);

  final SupabaseClient _client;
  final SupabaseStorageClient _storage;

  Future<String> uploadFile(File file) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User must be signed in.');
    }

    final fileName = p.basename(file.path);
    final storagePath = '$userId/$fileName';
    await _storage.from('documents').upload(
          storagePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    return storagePath;
  }

  Future<String> insertJob(
    String fromFormat,
    String toFormat,
    String storagePath,
    String fileName,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User must be signed in.');
    }

    // Create a document record first so conversion_jobs.document_id has a
    // valid UUID FK (and history can join back to it).
    final docResponse = await _client
        .from('documents')
        .insert(<String, dynamic>{
          'user_id': userId,
          'name': fileName,
          'type': fromFormat,
          'storage_path': storagePath,
        })
        .select('id')
        .single();
    final documentId = docResponse['id'] as String;

    final response = await _client
        .from('conversion_jobs')
        .insert(<String, dynamic>{
          'user_id': userId,
          'document_id': documentId,
          'from_format': fromFormat,
          'to_format': toFormat,
          'status': 'pending',
        })
        .select('id')
        .single();

    return response['id'] as String;
  }

  Future<void> callConvertEdgeFunction(
    String jobId,
    String storagePath,
    String fromFormat,
    String toFormat,
  ) async {
    await _client.functions.invoke(
      'convert-file',
      body: <String, dynamic>{
        'jobId': jobId,
        'storagePath': storagePath,
        'fromFormat': fromFormat,
        'toFormat': toFormat,
      },
    );
  }

  Stream<({String status, String? outputPath})> watchJobStatus(String jobId) {
    return _client
        .from('conversion_jobs')
        .stream(primaryKey: ['id'])
        .eq('id', jobId)
        .map((rows) {
          if (rows.isEmpty) {
            return (status: 'processing', outputPath: null);
          }

          final row = rows.first;
          return (
            status: row['status']?.toString() ?? 'processing',
            outputPath: row['output_path'] as String?,
          );
        });
  }

  Future<String> getSignedDownloadUrl(String outputPath) async {
    // The cloudconvert-webhook uploads converted files to the `processed`
    // bucket, not `documents`.
    return _storage.from('processed').createSignedUrl(outputPath, 60 * 60);
  }

  /// Whether the current user can start another conversion this period.
  Future<bool> canConvert() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    final quota = await _client
        .from('usage_quotas')
        .select('conversions_used')
        .eq('user_id', userId)
        .maybeSingle();
    final profile = await _client
        .from('profiles')
        .select('plan')
        .eq('id', userId)
        .maybeSingle();

    if (profile?['plan'] == 'plus') return true;
    final used = (quota?['conversions_used'] as int?) ?? 0;
    return used < kFreeConversionLimit;
  }

  Future<void> incrementConversionCount() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    await _client.rpc('increment_conversions_used', params: {'p_user_id': userId});
  }
}
