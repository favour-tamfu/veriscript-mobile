import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../local_db/app_database.dart';
import '../notifications/notification_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) => SyncService(ref));

class SyncService {
  SyncService(this._ref);

  final Ref _ref;

  AppDatabase get _db => _ref.read(appDatabaseProvider);
  SupabaseClient get _client => Supabase.instance.client;
  NotificationService get _notifications => _ref.read(notificationServiceProvider);

  Future<void> processQueue() async {
    final pendingItems = await (_db.select(_db.syncQueueTable)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.createdAt)]))
        .get();

    if (pendingItems.isEmpty) return;

    int successCount = 0;

    for (final item in pendingItems) {
      try {
        final payload = jsonDecode(item.payload) as Map<String, dynamic>;
        await _processItem(item.action, payload);
        await (_db.delete(_db.syncQueueTable)..where((t) => t.id.equals(item.id))).go();
        successCount++;
      } catch (_) {
        final newRetryCount = item.retryCount + 1;
        final newStatus = newRetryCount >= 3 ? 'failed' : 'pending';
        await (_db.update(_db.syncQueueTable)..where((t) => t.id.equals(item.id)))
            .write(SyncQueueTableCompanion(
          retryCount: drift.Value(newRetryCount),
          status: drift.Value(newStatus),
        ));
      }
    }

    if (successCount > 0) {
      await _notifications.showSyncComplete(successCount);
    }
  }

  Future<void> _processItem(String action, Map<String, dynamic> payload) async {
    switch (action) {
      case 'upload_document':
        await _client.from('documents').insert(payload);
        break;
      case 'delete_document':
        final docId = payload['document_id'] as String;
        final storagePath = payload['storage_path'] as String;
        if (storagePath.isNotEmpty) {
          await _client.storage.from('documents').remove([storagePath]);
        }
        await _client.from('documents').delete().eq('id', docId);
        break;
      case 'update_quota':
        await _client.rpc('increment_scans_used', params: {
          'p_user_id': payload['user_id'],
        });
        break;
    }
  }

  Future<void> enqueue(String action, Map<String, dynamic> payload) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _db.into(_db.syncQueueTable).insert(SyncQueueTableCompanion.insert(
      id: id,
      action: action,
      payload: jsonEncode(payload),
    ));
  }
}
