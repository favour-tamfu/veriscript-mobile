part of '../app_database.dart';

class ConversionJobsTable extends Table {
  TextColumn get id => text()();

  TextColumn get documentId => text()();

  TextColumn get userId => text()();

  TextColumn get fromFormat => text()();

  TextColumn get toFormat => text()();

  TextColumn get status => text()();

  TextColumn get outputPath => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
