import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/network/edge_function_caller.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../domain/scan_job.dart';

final scanRepositoryProvider = Provider<ScanRepository>(
  (ref) => ScanRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(edgeFunctionCallerProvider),
  ),
);

class ScanRepository {
  ScanRepository(this._client, this._edgeFunctionCaller);

  final SupabaseClient _client;
  final EdgeFunctionCaller _edgeFunctionCaller;

  Future<String> uploadDocument(File file, String userId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${timestamp}_${file.path.split('/').last.split('\\').last}';
    final storagePath = '$userId/$fileName';

    await _client.storage.from('documents').upload(storagePath, file);
    return storagePath;
  }

  Future<({String documentId, String reportId})> createScanJob(
    String storagePath,
    String fileName,
    String fileType,
    String userId,
  ) async {
    final docResponse = await _client
        .from('documents')
        .insert({
          'user_id': userId,
          'name': fileName,
          'type': fileType,
          'storage_path': storagePath,
        })
        .select('id')
        .single();
    final documentId = docResponse['id'] as String;

    final reportResponse = await _client
        .from('scan_reports')
        .insert({
          'document_id': documentId,
          'user_id': userId,
          'status': 'pending',
        })
        .select('id')
        .single();
    final reportId = reportResponse['id'] as String;

    return (documentId: documentId, reportId: reportId);
  }

  Future<void> startScan(
    String reportId,
    String storagePath,
    String documentId,
    String userId,
  ) async {
    await _edgeFunctionCaller.invoke('scan-document', body: {
      'jobId': reportId,
      'storagePath': storagePath,
      'documentId': documentId,
      'userId': userId,
    });
  }

  Stream<ScanJob> watchScanJob(String reportId) {
    return _client
        .from('scan_reports')
        .stream(primaryKey: ['id'])
        .eq('id', reportId)
        .map((rows) {
          if (rows.isEmpty) throw Exception('Scan report not found');
          return _rowToScanJob(rows.first);
        });
  }

  Future<ScanJob> getScanReport(String reportId) async {
    final data = await _client
        .from('scan_reports')
        .select()
        .eq('id', reportId)
        .single();
    return _rowToScanJob(data);
  }

  Future<void> incrementScanCount(String userId) async {
    await _client.rpc('increment_scans_used', params: {'p_user_id': userId});
  }

  Future<bool> canScan(String userId) async {
    final data = await _client
        .from('usage_quotas')
        .select('scans_used')
        .eq('user_id', userId)
        .maybeSingle();

    final profile = await _client
        .from('profiles')
        .select('bonus_scans, plan')
        .eq('id', userId)
        .maybeSingle();

    final scansUsed = (data?['scans_used'] as int?) ?? 0;
    final bonusScans = (profile?['bonus_scans'] as int?) ?? 0;
    final isPlusUser = profile?['plan'] == 'plus';

    if (isPlusUser) return true;
    return scansUsed < (3 + bonusScans);
  }

  ScanJob _rowToScanJob(Map<String, dynamic> row) {
    List<ScanSource>? sources;
    final sourcesJson = row['sources'] as String?;
    if (sourcesJson != null && sourcesJson.isNotEmpty) {
      final decoded = jsonDecode(sourcesJson) as List;
      sources = decoded
          .map((s) => ScanSource.fromJson(s as Map<String, dynamic>))
          .toList();
    }

    return ScanJob(
      id: row['id'] as String,
      documentId: row['document_id'] as String,
      userId: row['user_id'] as String,
      status: row['status'] as String,
      similarityPct: (row['similarity_pct'] as num?)?.toDouble(),
      sources: sources,
      reportPdfUrl: row['report_pdf_url'] as String?,
      externalScanId: row['external_scan_id'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
