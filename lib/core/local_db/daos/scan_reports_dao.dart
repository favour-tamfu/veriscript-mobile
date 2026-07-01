part of '../app_database.dart';

@DriftAccessor(tables: [ScanReportsTable])
class ScanReportsDao extends DatabaseAccessor<AppDatabase>
    with _$ScanReportsDaoMixin {
  ScanReportsDao(super.db);

  Future<void> insertReport(ScanReportsTableCompanion entry) {
    return into(scanReportsTable).insertOnConflictUpdate(entry);
  }

  Stream<List<ScanReportsTableData>> watchRecentReports(
    String userId, {
    int limit = 30,
  }) {
    final query = select(scanReportsTable)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
      ..limit(limit);
    return query.watch();
  }

  Future<void> updateStatus(
    String id,
    String status, {
    double? similarityPct,
  }) async {
    await (update(scanReportsTable)..where((tbl) => tbl.id.equals(id))).write(
      ScanReportsTableCompanion(
        status: Value(status),
        similarityPct: similarityPct == null
            ? const Value.absent()
            : Value(similarityPct),
      ),
    );
  }
}
