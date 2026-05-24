part of '../app_database.dart';

@DriftAccessor(tables: [DocumentsTable])
class DocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentsDaoMixin {
  DocumentsDao(super.db);

  Future<void> insertDocument(DocumentsTableCompanion entry) {
    return into(documentsTable).insertOnConflictUpdate(entry);
  }

  Future<List<DocumentsTableData>> getRecentDocuments(
    String userId, {
    int limit = 10,
  }) {
    final query = select(documentsTable)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
      ..limit(limit);
    return query.get();
  }

  Stream<List<DocumentsTableData>> watchAllDocuments(String userId) {
    final query = select(documentsTable)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return query.watch();
  }

  Future<int> deleteDocument(String id) {
    return (delete(documentsTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}
