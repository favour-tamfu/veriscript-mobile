part of '../app_database.dart';

class ScanReportsTable extends Table {
  TextColumn get id => text()();

  TextColumn get documentId => text()();

  TextColumn get userId => text()();

  RealColumn get similarityPct => real().nullable()();

  TextColumn get status => text()();

  TextColumn get sourcesJson => text().nullable()();

  TextColumn get reportPdfUrl => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
