import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';

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
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User must be signed in.');
    }

    final response = await _client
        .from('conversion_jobs')
        .insert(<String, dynamic>{
          'user_id': userId,
          'document_id': storagePath,
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

  Stream<String> watchJobStatus(String jobId) {
    return _client
        .from('conversion_jobs')
        .stream(primaryKey: ['id'])
        .eq('id', jobId)
        .map((rows) {
          if (rows.isEmpty) {
            return 'processing';
          }

          return rows.first['status']?.toString() ?? 'processing';
        });
  }

  Future<String> getSignedDownloadUrl(String outputPath) async {
    return _storage.from('documents').createSignedUrl(outputPath, 60 * 60);
  }
}
