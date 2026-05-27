part of '../app_database.dart';

class SyncQueueTable extends Table {
  TextColumn get id => text()();
  TextColumn get action => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const drift.Constant(0))();
  TextColumn get status => text().withDefault(const drift.Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
