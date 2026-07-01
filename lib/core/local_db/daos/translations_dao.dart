part of '../app_database.dart';

@DriftAccessor(tables: [TranslationsTable])
class TranslationsDao extends DatabaseAccessor<AppDatabase>
    with _$TranslationsDaoMixin {
  TranslationsDao(super.db);

  Future<void> cacheTranslation(TranslationsTableCompanion entry) {
    return into(translationsTable).insertOnConflictUpdate(entry);
  }

  Future<TranslationsTableData?> findCached(
    String userId,
    String inputText,
    String source,
    String target,
  ) {
    final query = select(translationsTable)
      ..where((tbl) =>
          tbl.userId.equals(userId) &
          tbl.inputText.equals(inputText) &
          tbl.sourceLang.equals(source) &
          tbl.targetLang.equals(target))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Stream<List<TranslationsTableData>> watchRecent(
    String userId, {
    int limit = 20,
  }) {
    final query = select(translationsTable)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
      ..limit(limit);
    return query.watch();
  }
}
