part of '../app_database.dart';

class DocumentsTable extends Table {
  TextColumn get id => text()();

  TextColumn get userId => text()();

  TextColumn get name => text()();

  TextColumn get type => text()();

  TextColumn get storagePath => text()();

  IntColumn get sizeBytes => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
