import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/local_db/app_database.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../domain/history_item.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(documentsDaoProvider),
  ),
);

class HistoryRepository {
  HistoryRepository(this._client, this._documentsDao);

  final SupabaseClient _client;
  final DocumentsDao _documentsDao;

  Future<List<HistoryItem>> fetchRemoteHistory(
    String userId, {
    int page = 0,
    int pageSize = 20,
  }) async {
    final offset = page * pageSize;

    final docs = await _client
        .from('documents')
        .select('id, name, type, storage_path, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + pageSize - 1);

    final items = <HistoryItem>[];
    for (final doc in docs) {
      final docId = doc['id'] as String;

      // Check for scan report
      final scan = await _client
          .from('scan_reports')
          .select('id, status, similarity_pct')
          .eq('document_id', docId)
          .maybeSingle();

      if (scan != null) {
        items.add(HistoryItem(
          id: scan['id'] as String,
          documentId: docId,
          name: doc['name'] as String,
          type: doc['type'] as String,
          action: 'scan',
          status: scan['status'] as String,
          createdAt: DateTime.parse(doc['created_at'] as String),
          similarityPct: (scan['similarity_pct'] as num?)?.toDouble(),
        ));
        continue;
      }

      // Check for conversion job
      final conv = await _client
          .from('conversion_jobs')
          .select('id, status, from_format, to_format')
          .eq('document_id', docId)
          .maybeSingle();

      if (conv != null) {
        items.add(HistoryItem(
          id: conv['id'] as String,
          documentId: docId,
          name: doc['name'] as String,
          type: doc['type'] as String,
          action: 'convert',
          status: conv['status'] as String,
          createdAt: DateTime.parse(doc['created_at'] as String),
          fromFormat: conv['from_format'] as String?,
          toFormat: conv['to_format'] as String?,
        ));
        continue;
      }

      // Default: document-only entry
      items.add(HistoryItem(
        id: docId,
        documentId: docId,
        name: doc['name'] as String,
        type: doc['type'] as String,
        action: 'scan',
        status: 'done',
        createdAt: DateTime.parse(doc['created_at'] as String),
      ));
    }

    return items;
  }

  Future<void> syncToLocal(List<HistoryItem> items) async {
    for (final item in items) {
      await _documentsDao.insertDocument(DocumentsTableCompanion.insert(
        id: item.documentId,
        userId: _client.auth.currentUser?.id ?? '',
        name: item.name,
        type: item.type,
        storagePath: '',
        createdAt: drift.Value(item.createdAt),
      ));
    }
  }

  Stream<List<HistoryItem>> watchLocalHistory(String userId) {
    return _documentsDao.watchAllDocuments(userId).map((docs) => docs
        .map((doc) => HistoryItem(
              id: doc.id,
              documentId: doc.id,
              name: doc.name,
              type: doc.type,
              action: 'scan',
              status: 'done',
              createdAt: doc.createdAt,
            ))
        .toList());
  }

  Future<void> deleteDocument(String documentId, String storagePath, String userId) async {
    if (storagePath.isNotEmpty) {
      try {
        await _client.storage.from('documents').remove([storagePath]);
      } catch (_) {}
    }
    await _client.from('documents').delete().eq('id', documentId);
    await _documentsDao.deleteDocument(documentId);
  }

  Stream<List<HistoryItem>> searchLocalHistory(String userId, String query) {
    return _documentsDao.watchAllDocuments(userId).map((docs) => docs
        .where((doc) => doc.name.toLowerCase().contains(query.toLowerCase()))
        .map((doc) => HistoryItem(
              id: doc.id,
              documentId: doc.id,
              name: doc.name,
              type: doc.type,
              action: 'scan',
              status: 'done',
              createdAt: doc.createdAt,
            ))
        .toList());
  }
}
