import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Documents extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get sourcePath => text().nullable()();

  TextColumn get targetFormat => text().nullable()();

  TextColumn get kind => text()();

  TextColumn get status => text()();

  TextColumn get details => text().nullable()();

  TextColumn get remoteUrl => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Documents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Document>> watchRecentDocuments({int limit = 5}) {
    final query = select(documents)
      ..orderBy([
        (tbl) => OrderingTerm(
          expression: tbl.updatedAt,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(limit);

    return query.watch();
  }

  Stream<List<Document>> watchAllDocuments() {
    final query = select(documents)
      ..orderBy([
        (tbl) => OrderingTerm(
          expression: tbl.updatedAt,
          mode: OrderingMode.desc,
        ),
      ]);

    return query.watch();
  }

  Future<void> saveDocument(DocumentsCompanion entry) {
    return into(documents).insertOnConflictUpdate(entry);
  }

  Future<void> deleteDocumentById(String id) {
    return (delete(documents)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'veriscript.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
