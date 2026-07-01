part of '../app_database.dart';

class TranslationsTable extends Table {
  TextColumn get id => text()();

  TextColumn get userId => text()();

  TextColumn get documentId => text().nullable()();

  TextColumn get sourceLang => text()();

  TextColumn get targetLang => text()();

  TextColumn get inputText => text()();

  TextColumn get outputText => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
