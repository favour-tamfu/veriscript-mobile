import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';
part 'tables/documents_table.dart';
part 'tables/scan_reports_table.dart';
part 'tables/translations_table.dart';
part 'tables/conversion_jobs_table.dart';
part 'daos/documents_dao.dart';
part 'daos/scan_reports_dao.dart';
part 'daos/translations_dao.dart';

@DriftDatabase(
  tables: [
    DocumentsTable,
    ScanReportsTable,
    TranslationsTable,
    ConversionJobsTable,
  ],
  daos: [
    DocumentsDao,
    ScanReportsDao,
    TranslationsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'veriscipt.db'));
    return NativeDatabase.createInBackground(file);
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final documentsDaoProvider = Provider<DocumentsDao>(
  (ref) => ref.watch(appDatabaseProvider).documentsDao,
);

final scanReportsDaoProvider = Provider<ScanReportsDao>(
  (ref) => ref.watch(appDatabaseProvider).scanReportsDao,
);

final translationsDaoProvider = Provider<TranslationsDao>(
  (ref) => ref.watch(appDatabaseProvider).translationsDao,
);
