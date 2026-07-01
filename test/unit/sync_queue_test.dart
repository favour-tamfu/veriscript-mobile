import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:veriscipt_mobile/core/local_db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  group('SyncQueueTable — enqueue', () {
    test('inserts a row with correct action and payload', () async {
      final payload = jsonEncode({'user_id': 'user-123'});
      await db.into(db.syncQueueTable).insert(
            SyncQueueTableCompanion.insert(
              id: '1001',
              action: 'update_quota',
              payload: payload,
            ),
          );

      final rows = await db.select(db.syncQueueTable).get();
      expect(rows.length, 1);
      expect(rows.first.action, 'update_quota');
      expect(rows.first.payload, payload);
      expect(rows.first.status, 'pending');
      expect(rows.first.retryCount, 0);
    });

    test('inserts multiple items in FIFO order', () async {
      for (var i = 1; i <= 3; i++) {
        await db.into(db.syncQueueTable).insert(
              SyncQueueTableCompanion.insert(
                id: '$i',
                action: 'upload_document',
                payload: jsonEncode({'doc_id': 'doc-$i'}),
              ),
            );
      }
      final rows = await (db.select(db.syncQueueTable)
            ..orderBy([(t) => drift.OrderingTerm.asc(t.createdAt)]))
          .get();

      expect(rows.length, 3);
      expect(rows.map((r) => r.id), containsAllInOrder(['1', '2', '3']));
    });
  });

  group('SyncQueueTable — status transitions', () {
    test('item can be updated to failed after 3 retries', () async {
      await db.into(db.syncQueueTable).insert(
            SyncQueueTableCompanion.insert(
              id: 'item-1',
              action: 'delete_document',
              payload: jsonEncode({'document_id': 'doc-abc', 'storage_path': 'user/doc.pdf'}),
            ),
          );

      // Simulate 3 retry increments
      for (var retry = 1; retry <= 3; retry++) {
        final newStatus = retry >= 3 ? 'failed' : 'pending';
        await (db.update(db.syncQueueTable)
              ..where((t) => t.id.equals('item-1')))
            .write(SyncQueueTableCompanion(
          retryCount: drift.Value(retry),
          status: drift.Value(newStatus),
        ));
      }

      final row = await (db.select(db.syncQueueTable)
            ..where((t) => t.id.equals('item-1')))
          .getSingle();
      expect(row.retryCount, 3);
      expect(row.status, 'failed');
    });

    test('item can be deleted after successful processing', () async {
      await db.into(db.syncQueueTable).insert(
            SyncQueueTableCompanion.insert(
              id: 'item-done',
              action: 'update_quota',
              payload: jsonEncode({'user_id': 'u1'}),
            ),
          );

      await (db.delete(db.syncQueueTable)
            ..where((t) => t.id.equals('item-done')))
          .go();

      final rows = await db.select(db.syncQueueTable).get();
      expect(rows, isEmpty);
    });
  });

  group('SyncQueueTable — pending query', () {
    test('only pending items are returned', () async {
      await db.into(db.syncQueueTable).insert(
            SyncQueueTableCompanion.insert(
              id: 'p1',
              action: 'upload_document',
              payload: '{}',
            ),
          );
      await db.into(db.syncQueueTable).insert(
            SyncQueueTableCompanion.insert(
              id: 'f1',
              action: 'upload_document',
              payload: '{}',
            ),
          );
      // Mark f1 as failed
      await (db.update(db.syncQueueTable)..where((t) => t.id.equals('f1')))
          .write(const SyncQueueTableCompanion(status: drift.Value('failed')));

      final pending = await (db.select(db.syncQueueTable)
            ..where((t) => t.status.equals('pending')))
          .get();

      expect(pending.length, 1);
      expect(pending.first.id, 'p1');
    });
  });
}
