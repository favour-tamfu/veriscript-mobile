// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DocumentsTableTable extends DocumentsTable
    with TableInfo<$DocumentsTableTable, DocumentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storagePathMeta =
      const VerificationMeta('storagePath');
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
      'storage_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sizeBytesMeta =
      const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
      'size_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, name, type, storagePath, sizeBytes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents_table';
  @override
  VerificationContext validateIntegrity(Insertable<DocumentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('storage_path')) {
      context.handle(
          _storagePathMeta,
          storagePath.isAcceptableOrUnknown(
              data['storage_path']!, _storagePathMeta));
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta,
          sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      storagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}storage_path'])!,
      sizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size_bytes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DocumentsTableTable createAlias(String alias) {
    return $DocumentsTableTable(attachedDatabase, alias);
  }
}

class DocumentsTableData extends DataClass
    implements Insertable<DocumentsTableData> {
  final String id;
  final String userId;
  final String name;
  final String type;
  final String storagePath;
  final int? sizeBytes;
  final DateTime createdAt;
  const DocumentsTableData(
      {required this.id,
      required this.userId,
      required this.name,
      required this.type,
      required this.storagePath,
      this.sizeBytes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['storage_path'] = Variable<String>(storagePath);
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocumentsTableCompanion toCompanion(bool nullToAbsent) {
    return DocumentsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      type: Value(type),
      storagePath: Value(storagePath),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeBytes),
      createdAt: Value(createdAt),
    );
  }

  factory DocumentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      storagePath: serializer.fromJson<String>(json['storagePath']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'storagePath': serializer.toJson<String>(storagePath),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocumentsTableData copyWith(
          {String? id,
          String? userId,
          String? name,
          String? type,
          String? storagePath,
          Value<int?> sizeBytes = const Value.absent(),
          DateTime? createdAt}) =>
      DocumentsTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        type: type ?? this.type,
        storagePath: storagePath ?? this.storagePath,
        sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
        createdAt: createdAt ?? this.createdAt,
      );
  DocumentsTableData copyWithCompanion(DocumentsTableCompanion data) {
    return DocumentsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      storagePath:
          data.storagePath.present ? data.storagePath.value : this.storagePath,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('storagePath: $storagePath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, name, type, storagePath, sizeBytes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.type == this.type &&
          other.storagePath == this.storagePath &&
          other.sizeBytes == this.sizeBytes &&
          other.createdAt == this.createdAt);
}

class DocumentsTableCompanion extends UpdateCompanion<DocumentsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> type;
  final Value<String> storagePath;
  final Value<int?> sizeBytes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DocumentsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsTableCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String type,
    required String storagePath,
    this.sizeBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        type = Value(type),
        storagePath = Value(storagePath);
  static Insertable<DocumentsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? storagePath,
    Expression<int>? sizeBytes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (storagePath != null) 'storage_path': storagePath,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String>? type,
      Value<String>? storagePath,
      Value<int?>? sizeBytes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return DocumentsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      storagePath: storagePath ?? this.storagePath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('storagePath: $storagePath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanReportsTableTable extends ScanReportsTable
    with TableInfo<$ScanReportsTableTable, ScanReportsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanReportsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
      'document_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _similarityPctMeta =
      const VerificationMeta('similarityPct');
  @override
  late final GeneratedColumn<double> similarityPct = GeneratedColumn<double>(
      'similarity_pct', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourcesJsonMeta =
      const VerificationMeta('sourcesJson');
  @override
  late final GeneratedColumn<String> sourcesJson = GeneratedColumn<String>(
      'sources_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reportPdfUrlMeta =
      const VerificationMeta('reportPdfUrl');
  @override
  late final GeneratedColumn<String> reportPdfUrl = GeneratedColumn<String>(
      'report_pdf_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        documentId,
        userId,
        similarityPct,
        status,
        sourcesJson,
        reportPdfUrl,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_reports_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ScanReportsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('similarity_pct')) {
      context.handle(
          _similarityPctMeta,
          similarityPct.isAcceptableOrUnknown(
              data['similarity_pct']!, _similarityPctMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('sources_json')) {
      context.handle(
          _sourcesJsonMeta,
          sourcesJson.isAcceptableOrUnknown(
              data['sources_json']!, _sourcesJsonMeta));
    }
    if (data.containsKey('report_pdf_url')) {
      context.handle(
          _reportPdfUrlMeta,
          reportPdfUrl.isAcceptableOrUnknown(
              data['report_pdf_url']!, _reportPdfUrlMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanReportsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanReportsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      similarityPct: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}similarity_pct']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      sourcesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sources_json']),
      reportPdfUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_pdf_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ScanReportsTableTable createAlias(String alias) {
    return $ScanReportsTableTable(attachedDatabase, alias);
  }
}

class ScanReportsTableData extends DataClass
    implements Insertable<ScanReportsTableData> {
  final String id;
  final String documentId;
  final String userId;
  final double? similarityPct;
  final String status;
  final String? sourcesJson;
  final String? reportPdfUrl;
  final DateTime createdAt;
  const ScanReportsTableData(
      {required this.id,
      required this.documentId,
      required this.userId,
      this.similarityPct,
      required this.status,
      this.sourcesJson,
      this.reportPdfUrl,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['document_id'] = Variable<String>(documentId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || similarityPct != null) {
      map['similarity_pct'] = Variable<double>(similarityPct);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || sourcesJson != null) {
      map['sources_json'] = Variable<String>(sourcesJson);
    }
    if (!nullToAbsent || reportPdfUrl != null) {
      map['report_pdf_url'] = Variable<String>(reportPdfUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScanReportsTableCompanion toCompanion(bool nullToAbsent) {
    return ScanReportsTableCompanion(
      id: Value(id),
      documentId: Value(documentId),
      userId: Value(userId),
      similarityPct: similarityPct == null && nullToAbsent
          ? const Value.absent()
          : Value(similarityPct),
      status: Value(status),
      sourcesJson: sourcesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcesJson),
      reportPdfUrl: reportPdfUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(reportPdfUrl),
      createdAt: Value(createdAt),
    );
  }

  factory ScanReportsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanReportsTableData(
      id: serializer.fromJson<String>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      userId: serializer.fromJson<String>(json['userId']),
      similarityPct: serializer.fromJson<double?>(json['similarityPct']),
      status: serializer.fromJson<String>(json['status']),
      sourcesJson: serializer.fromJson<String?>(json['sourcesJson']),
      reportPdfUrl: serializer.fromJson<String?>(json['reportPdfUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentId': serializer.toJson<String>(documentId),
      'userId': serializer.toJson<String>(userId),
      'similarityPct': serializer.toJson<double?>(similarityPct),
      'status': serializer.toJson<String>(status),
      'sourcesJson': serializer.toJson<String?>(sourcesJson),
      'reportPdfUrl': serializer.toJson<String?>(reportPdfUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScanReportsTableData copyWith(
          {String? id,
          String? documentId,
          String? userId,
          Value<double?> similarityPct = const Value.absent(),
          String? status,
          Value<String?> sourcesJson = const Value.absent(),
          Value<String?> reportPdfUrl = const Value.absent(),
          DateTime? createdAt}) =>
      ScanReportsTableData(
        id: id ?? this.id,
        documentId: documentId ?? this.documentId,
        userId: userId ?? this.userId,
        similarityPct:
            similarityPct.present ? similarityPct.value : this.similarityPct,
        status: status ?? this.status,
        sourcesJson: sourcesJson.present ? sourcesJson.value : this.sourcesJson,
        reportPdfUrl:
            reportPdfUrl.present ? reportPdfUrl.value : this.reportPdfUrl,
        createdAt: createdAt ?? this.createdAt,
      );
  ScanReportsTableData copyWithCompanion(ScanReportsTableCompanion data) {
    return ScanReportsTableData(
      id: data.id.present ? data.id.value : this.id,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      userId: data.userId.present ? data.userId.value : this.userId,
      similarityPct: data.similarityPct.present
          ? data.similarityPct.value
          : this.similarityPct,
      status: data.status.present ? data.status.value : this.status,
      sourcesJson:
          data.sourcesJson.present ? data.sourcesJson.value : this.sourcesJson,
      reportPdfUrl: data.reportPdfUrl.present
          ? data.reportPdfUrl.value
          : this.reportPdfUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanReportsTableData(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('userId: $userId, ')
          ..write('similarityPct: $similarityPct, ')
          ..write('status: $status, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('reportPdfUrl: $reportPdfUrl, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, documentId, userId, similarityPct, status,
      sourcesJson, reportPdfUrl, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanReportsTableData &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.userId == this.userId &&
          other.similarityPct == this.similarityPct &&
          other.status == this.status &&
          other.sourcesJson == this.sourcesJson &&
          other.reportPdfUrl == this.reportPdfUrl &&
          other.createdAt == this.createdAt);
}

class ScanReportsTableCompanion extends UpdateCompanion<ScanReportsTableData> {
  final Value<String> id;
  final Value<String> documentId;
  final Value<String> userId;
  final Value<double?> similarityPct;
  final Value<String> status;
  final Value<String?> sourcesJson;
  final Value<String?> reportPdfUrl;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScanReportsTableCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.userId = const Value.absent(),
    this.similarityPct = const Value.absent(),
    this.status = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.reportPdfUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanReportsTableCompanion.insert({
    required String id,
    required String documentId,
    required String userId,
    this.similarityPct = const Value.absent(),
    required String status,
    this.sourcesJson = const Value.absent(),
    this.reportPdfUrl = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        documentId = Value(documentId),
        userId = Value(userId),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<ScanReportsTableData> custom({
    Expression<String>? id,
    Expression<String>? documentId,
    Expression<String>? userId,
    Expression<double>? similarityPct,
    Expression<String>? status,
    Expression<String>? sourcesJson,
    Expression<String>? reportPdfUrl,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (userId != null) 'user_id': userId,
      if (similarityPct != null) 'similarity_pct': similarityPct,
      if (status != null) 'status': status,
      if (sourcesJson != null) 'sources_json': sourcesJson,
      if (reportPdfUrl != null) 'report_pdf_url': reportPdfUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanReportsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? documentId,
      Value<String>? userId,
      Value<double?>? similarityPct,
      Value<String>? status,
      Value<String?>? sourcesJson,
      Value<String?>? reportPdfUrl,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ScanReportsTableCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      similarityPct: similarityPct ?? this.similarityPct,
      status: status ?? this.status,
      sourcesJson: sourcesJson ?? this.sourcesJson,
      reportPdfUrl: reportPdfUrl ?? this.reportPdfUrl,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (similarityPct.present) {
      map['similarity_pct'] = Variable<double>(similarityPct.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sourcesJson.present) {
      map['sources_json'] = Variable<String>(sourcesJson.value);
    }
    if (reportPdfUrl.present) {
      map['report_pdf_url'] = Variable<String>(reportPdfUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanReportsTableCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('userId: $userId, ')
          ..write('similarityPct: $similarityPct, ')
          ..write('status: $status, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('reportPdfUrl: $reportPdfUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TranslationsTableTable extends TranslationsTable
    with TableInfo<$TranslationsTableTable, TranslationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
      'document_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceLangMeta =
      const VerificationMeta('sourceLang');
  @override
  late final GeneratedColumn<String> sourceLang = GeneratedColumn<String>(
      'source_lang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetLangMeta =
      const VerificationMeta('targetLang');
  @override
  late final GeneratedColumn<String> targetLang = GeneratedColumn<String>(
      'target_lang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inputTextMeta =
      const VerificationMeta('inputText');
  @override
  late final GeneratedColumn<String> inputText = GeneratedColumn<String>(
      'input_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _outputTextMeta =
      const VerificationMeta('outputText');
  @override
  late final GeneratedColumn<String> outputText = GeneratedColumn<String>(
      'output_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        documentId,
        sourceLang,
        targetLang,
        inputText,
        outputText,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translations_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TranslationsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    }
    if (data.containsKey('source_lang')) {
      context.handle(
          _sourceLangMeta,
          sourceLang.isAcceptableOrUnknown(
              data['source_lang']!, _sourceLangMeta));
    } else if (isInserting) {
      context.missing(_sourceLangMeta);
    }
    if (data.containsKey('target_lang')) {
      context.handle(
          _targetLangMeta,
          targetLang.isAcceptableOrUnknown(
              data['target_lang']!, _targetLangMeta));
    } else if (isInserting) {
      context.missing(_targetLangMeta);
    }
    if (data.containsKey('input_text')) {
      context.handle(_inputTextMeta,
          inputText.isAcceptableOrUnknown(data['input_text']!, _inputTextMeta));
    } else if (isInserting) {
      context.missing(_inputTextMeta);
    }
    if (data.containsKey('output_text')) {
      context.handle(
          _outputTextMeta,
          outputText.isAcceptableOrUnknown(
              data['output_text']!, _outputTextMeta));
    } else if (isInserting) {
      context.missing(_outputTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TranslationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranslationsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_id']),
      sourceLang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_lang'])!,
      targetLang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_lang'])!,
      inputText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_text'])!,
      outputText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}output_text'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TranslationsTableTable createAlias(String alias) {
    return $TranslationsTableTable(attachedDatabase, alias);
  }
}

class TranslationsTableData extends DataClass
    implements Insertable<TranslationsTableData> {
  final String id;
  final String userId;
  final String? documentId;
  final String sourceLang;
  final String targetLang;
  final String inputText;
  final String outputText;
  final DateTime createdAt;
  const TranslationsTableData(
      {required this.id,
      required this.userId,
      this.documentId,
      required this.sourceLang,
      required this.targetLang,
      required this.inputText,
      required this.outputText,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || documentId != null) {
      map['document_id'] = Variable<String>(documentId);
    }
    map['source_lang'] = Variable<String>(sourceLang);
    map['target_lang'] = Variable<String>(targetLang);
    map['input_text'] = Variable<String>(inputText);
    map['output_text'] = Variable<String>(outputText);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TranslationsTableCompanion toCompanion(bool nullToAbsent) {
    return TranslationsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      documentId: documentId == null && nullToAbsent
          ? const Value.absent()
          : Value(documentId),
      sourceLang: Value(sourceLang),
      targetLang: Value(targetLang),
      inputText: Value(inputText),
      outputText: Value(outputText),
      createdAt: Value(createdAt),
    );
  }

  factory TranslationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranslationsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      documentId: serializer.fromJson<String?>(json['documentId']),
      sourceLang: serializer.fromJson<String>(json['sourceLang']),
      targetLang: serializer.fromJson<String>(json['targetLang']),
      inputText: serializer.fromJson<String>(json['inputText']),
      outputText: serializer.fromJson<String>(json['outputText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'documentId': serializer.toJson<String?>(documentId),
      'sourceLang': serializer.toJson<String>(sourceLang),
      'targetLang': serializer.toJson<String>(targetLang),
      'inputText': serializer.toJson<String>(inputText),
      'outputText': serializer.toJson<String>(outputText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TranslationsTableData copyWith(
          {String? id,
          String? userId,
          Value<String?> documentId = const Value.absent(),
          String? sourceLang,
          String? targetLang,
          String? inputText,
          String? outputText,
          DateTime? createdAt}) =>
      TranslationsTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        documentId: documentId.present ? documentId.value : this.documentId,
        sourceLang: sourceLang ?? this.sourceLang,
        targetLang: targetLang ?? this.targetLang,
        inputText: inputText ?? this.inputText,
        outputText: outputText ?? this.outputText,
        createdAt: createdAt ?? this.createdAt,
      );
  TranslationsTableData copyWithCompanion(TranslationsTableCompanion data) {
    return TranslationsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      sourceLang:
          data.sourceLang.present ? data.sourceLang.value : this.sourceLang,
      targetLang:
          data.targetLang.present ? data.targetLang.value : this.targetLang,
      inputText: data.inputText.present ? data.inputText.value : this.inputText,
      outputText:
          data.outputText.present ? data.outputText.value : this.outputText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('documentId: $documentId, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('inputText: $inputText, ')
          ..write('outputText: $outputText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, documentId, sourceLang,
      targetLang, inputText, outputText, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranslationsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.documentId == this.documentId &&
          other.sourceLang == this.sourceLang &&
          other.targetLang == this.targetLang &&
          other.inputText == this.inputText &&
          other.outputText == this.outputText &&
          other.createdAt == this.createdAt);
}

class TranslationsTableCompanion
    extends UpdateCompanion<TranslationsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> documentId;
  final Value<String> sourceLang;
  final Value<String> targetLang;
  final Value<String> inputText;
  final Value<String> outputText;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TranslationsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.documentId = const Value.absent(),
    this.sourceLang = const Value.absent(),
    this.targetLang = const Value.absent(),
    this.inputText = const Value.absent(),
    this.outputText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranslationsTableCompanion.insert({
    required String id,
    required String userId,
    this.documentId = const Value.absent(),
    required String sourceLang,
    required String targetLang,
    required String inputText,
    required String outputText,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        sourceLang = Value(sourceLang),
        targetLang = Value(targetLang),
        inputText = Value(inputText),
        outputText = Value(outputText),
        createdAt = Value(createdAt);
  static Insertable<TranslationsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? documentId,
    Expression<String>? sourceLang,
    Expression<String>? targetLang,
    Expression<String>? inputText,
    Expression<String>? outputText,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (documentId != null) 'document_id': documentId,
      if (sourceLang != null) 'source_lang': sourceLang,
      if (targetLang != null) 'target_lang': targetLang,
      if (inputText != null) 'input_text': inputText,
      if (outputText != null) 'output_text': outputText,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranslationsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String?>? documentId,
      Value<String>? sourceLang,
      Value<String>? targetLang,
      Value<String>? inputText,
      Value<String>? outputText,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TranslationsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      documentId: documentId ?? this.documentId,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      inputText: inputText ?? this.inputText,
      outputText: outputText ?? this.outputText,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (sourceLang.present) {
      map['source_lang'] = Variable<String>(sourceLang.value);
    }
    if (targetLang.present) {
      map['target_lang'] = Variable<String>(targetLang.value);
    }
    if (inputText.present) {
      map['input_text'] = Variable<String>(inputText.value);
    }
    if (outputText.present) {
      map['output_text'] = Variable<String>(outputText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('documentId: $documentId, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('inputText: $inputText, ')
          ..write('outputText: $outputText, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversionJobsTableTable extends ConversionJobsTable
    with TableInfo<$ConversionJobsTableTable, ConversionJobsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversionJobsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
      'document_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromFormatMeta =
      const VerificationMeta('fromFormat');
  @override
  late final GeneratedColumn<String> fromFormat = GeneratedColumn<String>(
      'from_format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toFormatMeta =
      const VerificationMeta('toFormat');
  @override
  late final GeneratedColumn<String> toFormat = GeneratedColumn<String>(
      'to_format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _outputPathMeta =
      const VerificationMeta('outputPath');
  @override
  late final GeneratedColumn<String> outputPath = GeneratedColumn<String>(
      'output_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        documentId,
        userId,
        fromFormat,
        toFormat,
        status,
        outputPath,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversion_jobs_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConversionJobsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('from_format')) {
      context.handle(
          _fromFormatMeta,
          fromFormat.isAcceptableOrUnknown(
              data['from_format']!, _fromFormatMeta));
    } else if (isInserting) {
      context.missing(_fromFormatMeta);
    }
    if (data.containsKey('to_format')) {
      context.handle(_toFormatMeta,
          toFormat.isAcceptableOrUnknown(data['to_format']!, _toFormatMeta));
    } else if (isInserting) {
      context.missing(_toFormatMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('output_path')) {
      context.handle(
          _outputPathMeta,
          outputPath.isAcceptableOrUnknown(
              data['output_path']!, _outputPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversionJobsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversionJobsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      fromFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_format'])!,
      toFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_format'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      outputPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}output_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ConversionJobsTableTable createAlias(String alias) {
    return $ConversionJobsTableTable(attachedDatabase, alias);
  }
}

class ConversionJobsTableData extends DataClass
    implements Insertable<ConversionJobsTableData> {
  final String id;
  final String documentId;
  final String userId;
  final String fromFormat;
  final String toFormat;
  final String status;
  final String? outputPath;
  final DateTime createdAt;
  const ConversionJobsTableData(
      {required this.id,
      required this.documentId,
      required this.userId,
      required this.fromFormat,
      required this.toFormat,
      required this.status,
      this.outputPath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['document_id'] = Variable<String>(documentId);
    map['user_id'] = Variable<String>(userId);
    map['from_format'] = Variable<String>(fromFormat);
    map['to_format'] = Variable<String>(toFormat);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || outputPath != null) {
      map['output_path'] = Variable<String>(outputPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ConversionJobsTableCompanion toCompanion(bool nullToAbsent) {
    return ConversionJobsTableCompanion(
      id: Value(id),
      documentId: Value(documentId),
      userId: Value(userId),
      fromFormat: Value(fromFormat),
      toFormat: Value(toFormat),
      status: Value(status),
      outputPath: outputPath == null && nullToAbsent
          ? const Value.absent()
          : Value(outputPath),
      createdAt: Value(createdAt),
    );
  }

  factory ConversionJobsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversionJobsTableData(
      id: serializer.fromJson<String>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      userId: serializer.fromJson<String>(json['userId']),
      fromFormat: serializer.fromJson<String>(json['fromFormat']),
      toFormat: serializer.fromJson<String>(json['toFormat']),
      status: serializer.fromJson<String>(json['status']),
      outputPath: serializer.fromJson<String?>(json['outputPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentId': serializer.toJson<String>(documentId),
      'userId': serializer.toJson<String>(userId),
      'fromFormat': serializer.toJson<String>(fromFormat),
      'toFormat': serializer.toJson<String>(toFormat),
      'status': serializer.toJson<String>(status),
      'outputPath': serializer.toJson<String?>(outputPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ConversionJobsTableData copyWith(
          {String? id,
          String? documentId,
          String? userId,
          String? fromFormat,
          String? toFormat,
          String? status,
          Value<String?> outputPath = const Value.absent(),
          DateTime? createdAt}) =>
      ConversionJobsTableData(
        id: id ?? this.id,
        documentId: documentId ?? this.documentId,
        userId: userId ?? this.userId,
        fromFormat: fromFormat ?? this.fromFormat,
        toFormat: toFormat ?? this.toFormat,
        status: status ?? this.status,
        outputPath: outputPath.present ? outputPath.value : this.outputPath,
        createdAt: createdAt ?? this.createdAt,
      );
  ConversionJobsTableData copyWithCompanion(ConversionJobsTableCompanion data) {
    return ConversionJobsTableData(
      id: data.id.present ? data.id.value : this.id,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      userId: data.userId.present ? data.userId.value : this.userId,
      fromFormat:
          data.fromFormat.present ? data.fromFormat.value : this.fromFormat,
      toFormat: data.toFormat.present ? data.toFormat.value : this.toFormat,
      status: data.status.present ? data.status.value : this.status,
      outputPath:
          data.outputPath.present ? data.outputPath.value : this.outputPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversionJobsTableData(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('userId: $userId, ')
          ..write('fromFormat: $fromFormat, ')
          ..write('toFormat: $toFormat, ')
          ..write('status: $status, ')
          ..write('outputPath: $outputPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, documentId, userId, fromFormat, toFormat,
      status, outputPath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversionJobsTableData &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.userId == this.userId &&
          other.fromFormat == this.fromFormat &&
          other.toFormat == this.toFormat &&
          other.status == this.status &&
          other.outputPath == this.outputPath &&
          other.createdAt == this.createdAt);
}

class ConversionJobsTableCompanion
    extends UpdateCompanion<ConversionJobsTableData> {
  final Value<String> id;
  final Value<String> documentId;
  final Value<String> userId;
  final Value<String> fromFormat;
  final Value<String> toFormat;
  final Value<String> status;
  final Value<String?> outputPath;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ConversionJobsTableCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.userId = const Value.absent(),
    this.fromFormat = const Value.absent(),
    this.toFormat = const Value.absent(),
    this.status = const Value.absent(),
    this.outputPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversionJobsTableCompanion.insert({
    required String id,
    required String documentId,
    required String userId,
    required String fromFormat,
    required String toFormat,
    required String status,
    this.outputPath = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        documentId = Value(documentId),
        userId = Value(userId),
        fromFormat = Value(fromFormat),
        toFormat = Value(toFormat),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<ConversionJobsTableData> custom({
    Expression<String>? id,
    Expression<String>? documentId,
    Expression<String>? userId,
    Expression<String>? fromFormat,
    Expression<String>? toFormat,
    Expression<String>? status,
    Expression<String>? outputPath,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (userId != null) 'user_id': userId,
      if (fromFormat != null) 'from_format': fromFormat,
      if (toFormat != null) 'to_format': toFormat,
      if (status != null) 'status': status,
      if (outputPath != null) 'output_path': outputPath,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversionJobsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? documentId,
      Value<String>? userId,
      Value<String>? fromFormat,
      Value<String>? toFormat,
      Value<String>? status,
      Value<String?>? outputPath,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ConversionJobsTableCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      fromFormat: fromFormat ?? this.fromFormat,
      toFormat: toFormat ?? this.toFormat,
      status: status ?? this.status,
      outputPath: outputPath ?? this.outputPath,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (fromFormat.present) {
      map['from_format'] = Variable<String>(fromFormat.value);
    }
    if (toFormat.present) {
      map['to_format'] = Variable<String>(toFormat.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (outputPath.present) {
      map['output_path'] = Variable<String>(outputPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversionJobsTableCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('userId: $userId, ')
          ..write('fromFormat: $fromFormat, ')
          ..write('toFormat: $toFormat, ')
          ..write('status: $status, ')
          ..write('outputPath: $outputPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DocumentsTableTable documentsTable = $DocumentsTableTable(this);
  late final $ScanReportsTableTable scanReportsTable =
      $ScanReportsTableTable(this);
  late final $TranslationsTableTable translationsTable =
      $TranslationsTableTable(this);
  late final $ConversionJobsTableTable conversionJobsTable =
      $ConversionJobsTableTable(this);
  late final DocumentsDao documentsDao = DocumentsDao(this as AppDatabase);
  late final ScanReportsDao scanReportsDao =
      ScanReportsDao(this as AppDatabase);
  late final TranslationsDao translationsDao =
      TranslationsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        documentsTable,
        scanReportsTable,
        translationsTable,
        conversionJobsTable
      ];
}

typedef $$DocumentsTableTableCreateCompanionBuilder = DocumentsTableCompanion
    Function({
  required String id,
  required String userId,
  required String name,
  required String type,
  required String storagePath,
  Value<int?> sizeBytes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$DocumentsTableTableUpdateCompanionBuilder = DocumentsTableCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> name,
  Value<String> type,
  Value<String> storagePath,
  Value<int?> sizeBytes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$DocumentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DocumentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DocumentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DocumentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTableTable,
    DocumentsTableData,
    $$DocumentsTableTableFilterComposer,
    $$DocumentsTableTableOrderingComposer,
    $$DocumentsTableTableAnnotationComposer,
    $$DocumentsTableTableCreateCompanionBuilder,
    $$DocumentsTableTableUpdateCompanionBuilder,
    (
      DocumentsTableData,
      BaseReferences<_$AppDatabase, $DocumentsTableTable, DocumentsTableData>
    ),
    DocumentsTableData,
    PrefetchHooks Function()> {
  $$DocumentsTableTableTableManager(
      _$AppDatabase db, $DocumentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> storagePath = const Value.absent(),
            Value<int?> sizeBytes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsTableCompanion(
            id: id,
            userId: userId,
            name: name,
            type: type,
            storagePath: storagePath,
            sizeBytes: sizeBytes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String name,
            required String type,
            required String storagePath,
            Value<int?> sizeBytes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsTableCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            type: type,
            storagePath: storagePath,
            sizeBytes: sizeBytes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTableTable,
    DocumentsTableData,
    $$DocumentsTableTableFilterComposer,
    $$DocumentsTableTableOrderingComposer,
    $$DocumentsTableTableAnnotationComposer,
    $$DocumentsTableTableCreateCompanionBuilder,
    $$DocumentsTableTableUpdateCompanionBuilder,
    (
      DocumentsTableData,
      BaseReferences<_$AppDatabase, $DocumentsTableTable, DocumentsTableData>
    ),
    DocumentsTableData,
    PrefetchHooks Function()>;
typedef $$ScanReportsTableTableCreateCompanionBuilder
    = ScanReportsTableCompanion Function({
  required String id,
  required String documentId,
  required String userId,
  Value<double?> similarityPct,
  required String status,
  Value<String?> sourcesJson,
  Value<String?> reportPdfUrl,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ScanReportsTableTableUpdateCompanionBuilder
    = ScanReportsTableCompanion Function({
  Value<String> id,
  Value<String> documentId,
  Value<String> userId,
  Value<double?> similarityPct,
  Value<String> status,
  Value<String?> sourcesJson,
  Value<String?> reportPdfUrl,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ScanReportsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ScanReportsTableTable> {
  $$ScanReportsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get similarityPct => $composableBuilder(
      column: $table.similarityPct, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reportPdfUrl => $composableBuilder(
      column: $table.reportPdfUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ScanReportsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanReportsTableTable> {
  $$ScanReportsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get similarityPct => $composableBuilder(
      column: $table.similarityPct,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reportPdfUrl => $composableBuilder(
      column: $table.reportPdfUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ScanReportsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanReportsTableTable> {
  $$ScanReportsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get similarityPct => $composableBuilder(
      column: $table.similarityPct, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson, builder: (column) => column);

  GeneratedColumn<String> get reportPdfUrl => $composableBuilder(
      column: $table.reportPdfUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ScanReportsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScanReportsTableTable,
    ScanReportsTableData,
    $$ScanReportsTableTableFilterComposer,
    $$ScanReportsTableTableOrderingComposer,
    $$ScanReportsTableTableAnnotationComposer,
    $$ScanReportsTableTableCreateCompanionBuilder,
    $$ScanReportsTableTableUpdateCompanionBuilder,
    (
      ScanReportsTableData,
      BaseReferences<_$AppDatabase, $ScanReportsTableTable,
          ScanReportsTableData>
    ),
    ScanReportsTableData,
    PrefetchHooks Function()> {
  $$ScanReportsTableTableTableManager(
      _$AppDatabase db, $ScanReportsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanReportsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanReportsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanReportsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> documentId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<double?> similarityPct = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> sourcesJson = const Value.absent(),
            Value<String?> reportPdfUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScanReportsTableCompanion(
            id: id,
            documentId: documentId,
            userId: userId,
            similarityPct: similarityPct,
            status: status,
            sourcesJson: sourcesJson,
            reportPdfUrl: reportPdfUrl,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String documentId,
            required String userId,
            Value<double?> similarityPct = const Value.absent(),
            required String status,
            Value<String?> sourcesJson = const Value.absent(),
            Value<String?> reportPdfUrl = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ScanReportsTableCompanion.insert(
            id: id,
            documentId: documentId,
            userId: userId,
            similarityPct: similarityPct,
            status: status,
            sourcesJson: sourcesJson,
            reportPdfUrl: reportPdfUrl,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScanReportsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScanReportsTableTable,
    ScanReportsTableData,
    $$ScanReportsTableTableFilterComposer,
    $$ScanReportsTableTableOrderingComposer,
    $$ScanReportsTableTableAnnotationComposer,
    $$ScanReportsTableTableCreateCompanionBuilder,
    $$ScanReportsTableTableUpdateCompanionBuilder,
    (
      ScanReportsTableData,
      BaseReferences<_$AppDatabase, $ScanReportsTableTable,
          ScanReportsTableData>
    ),
    ScanReportsTableData,
    PrefetchHooks Function()>;
typedef $$TranslationsTableTableCreateCompanionBuilder
    = TranslationsTableCompanion Function({
  required String id,
  required String userId,
  Value<String?> documentId,
  required String sourceLang,
  required String targetLang,
  required String inputText,
  required String outputText,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$TranslationsTableTableUpdateCompanionBuilder
    = TranslationsTableCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String?> documentId,
  Value<String> sourceLang,
  Value<String> targetLang,
  Value<String> inputText,
  Value<String> outputText,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$TranslationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationsTableTable> {
  $$TranslationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetLang => $composableBuilder(
      column: $table.targetLang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputText => $composableBuilder(
      column: $table.inputText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outputText => $composableBuilder(
      column: $table.outputText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TranslationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationsTableTable> {
  $$TranslationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetLang => $composableBuilder(
      column: $table.targetLang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputText => $composableBuilder(
      column: $table.inputText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outputText => $composableBuilder(
      column: $table.outputText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TranslationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationsTableTable> {
  $$TranslationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  GeneratedColumn<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => column);

  GeneratedColumn<String> get targetLang => $composableBuilder(
      column: $table.targetLang, builder: (column) => column);

  GeneratedColumn<String> get inputText =>
      $composableBuilder(column: $table.inputText, builder: (column) => column);

  GeneratedColumn<String> get outputText => $composableBuilder(
      column: $table.outputText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TranslationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranslationsTableTable,
    TranslationsTableData,
    $$TranslationsTableTableFilterComposer,
    $$TranslationsTableTableOrderingComposer,
    $$TranslationsTableTableAnnotationComposer,
    $$TranslationsTableTableCreateCompanionBuilder,
    $$TranslationsTableTableUpdateCompanionBuilder,
    (
      TranslationsTableData,
      BaseReferences<_$AppDatabase, $TranslationsTableTable,
          TranslationsTableData>
    ),
    TranslationsTableData,
    PrefetchHooks Function()> {
  $$TranslationsTableTableTableManager(
      _$AppDatabase db, $TranslationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> documentId = const Value.absent(),
            Value<String> sourceLang = const Value.absent(),
            Value<String> targetLang = const Value.absent(),
            Value<String> inputText = const Value.absent(),
            Value<String> outputText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TranslationsTableCompanion(
            id: id,
            userId: userId,
            documentId: documentId,
            sourceLang: sourceLang,
            targetLang: targetLang,
            inputText: inputText,
            outputText: outputText,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<String?> documentId = const Value.absent(),
            required String sourceLang,
            required String targetLang,
            required String inputText,
            required String outputText,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TranslationsTableCompanion.insert(
            id: id,
            userId: userId,
            documentId: documentId,
            sourceLang: sourceLang,
            targetLang: targetLang,
            inputText: inputText,
            outputText: outputText,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TranslationsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranslationsTableTable,
    TranslationsTableData,
    $$TranslationsTableTableFilterComposer,
    $$TranslationsTableTableOrderingComposer,
    $$TranslationsTableTableAnnotationComposer,
    $$TranslationsTableTableCreateCompanionBuilder,
    $$TranslationsTableTableUpdateCompanionBuilder,
    (
      TranslationsTableData,
      BaseReferences<_$AppDatabase, $TranslationsTableTable,
          TranslationsTableData>
    ),
    TranslationsTableData,
    PrefetchHooks Function()>;
typedef $$ConversionJobsTableTableCreateCompanionBuilder
    = ConversionJobsTableCompanion Function({
  required String id,
  required String documentId,
  required String userId,
  required String fromFormat,
  required String toFormat,
  required String status,
  Value<String?> outputPath,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ConversionJobsTableTableUpdateCompanionBuilder
    = ConversionJobsTableCompanion Function({
  Value<String> id,
  Value<String> documentId,
  Value<String> userId,
  Value<String> fromFormat,
  Value<String> toFormat,
  Value<String> status,
  Value<String?> outputPath,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ConversionJobsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConversionJobsTableTable> {
  $$ConversionJobsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromFormat => $composableBuilder(
      column: $table.fromFormat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toFormat => $composableBuilder(
      column: $table.toFormat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outputPath => $composableBuilder(
      column: $table.outputPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ConversionJobsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversionJobsTableTable> {
  $$ConversionJobsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromFormat => $composableBuilder(
      column: $table.fromFormat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toFormat => $composableBuilder(
      column: $table.toFormat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outputPath => $composableBuilder(
      column: $table.outputPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ConversionJobsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversionJobsTableTable> {
  $$ConversionJobsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get fromFormat => $composableBuilder(
      column: $table.fromFormat, builder: (column) => column);

  GeneratedColumn<String> get toFormat =>
      $composableBuilder(column: $table.toFormat, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get outputPath => $composableBuilder(
      column: $table.outputPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ConversionJobsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConversionJobsTableTable,
    ConversionJobsTableData,
    $$ConversionJobsTableTableFilterComposer,
    $$ConversionJobsTableTableOrderingComposer,
    $$ConversionJobsTableTableAnnotationComposer,
    $$ConversionJobsTableTableCreateCompanionBuilder,
    $$ConversionJobsTableTableUpdateCompanionBuilder,
    (
      ConversionJobsTableData,
      BaseReferences<_$AppDatabase, $ConversionJobsTableTable,
          ConversionJobsTableData>
    ),
    ConversionJobsTableData,
    PrefetchHooks Function()> {
  $$ConversionJobsTableTableTableManager(
      _$AppDatabase db, $ConversionJobsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversionJobsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversionJobsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversionJobsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> documentId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> fromFormat = const Value.absent(),
            Value<String> toFormat = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> outputPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversionJobsTableCompanion(
            id: id,
            documentId: documentId,
            userId: userId,
            fromFormat: fromFormat,
            toFormat: toFormat,
            status: status,
            outputPath: outputPath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String documentId,
            required String userId,
            required String fromFormat,
            required String toFormat,
            required String status,
            Value<String?> outputPath = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversionJobsTableCompanion.insert(
            id: id,
            documentId: documentId,
            userId: userId,
            fromFormat: fromFormat,
            toFormat: toFormat,
            status: status,
            outputPath: outputPath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConversionJobsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConversionJobsTableTable,
    ConversionJobsTableData,
    $$ConversionJobsTableTableFilterComposer,
    $$ConversionJobsTableTableOrderingComposer,
    $$ConversionJobsTableTableAnnotationComposer,
    $$ConversionJobsTableTableCreateCompanionBuilder,
    $$ConversionJobsTableTableUpdateCompanionBuilder,
    (
      ConversionJobsTableData,
      BaseReferences<_$AppDatabase, $ConversionJobsTableTable,
          ConversionJobsTableData>
    ),
    ConversionJobsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DocumentsTableTableTableManager get documentsTable =>
      $$DocumentsTableTableTableManager(_db, _db.documentsTable);
  $$ScanReportsTableTableTableManager get scanReportsTable =>
      $$ScanReportsTableTableTableManager(_db, _db.scanReportsTable);
  $$TranslationsTableTableTableManager get translationsTable =>
      $$TranslationsTableTableTableManager(_db, _db.translationsTable);
  $$ConversionJobsTableTableTableManager get conversionJobsTable =>
      $$ConversionJobsTableTableTableManager(_db, _db.conversionJobsTable);
}

mixin _$DocumentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DocumentsTableTable get documentsTable => attachedDatabase.documentsTable;
}
mixin _$ScanReportsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ScanReportsTableTable get scanReportsTable =>
      attachedDatabase.scanReportsTable;
}
mixin _$TranslationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TranslationsTableTable get translationsTable =>
      attachedDatabase.translationsTable;
}
