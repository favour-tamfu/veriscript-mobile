// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DocumentsTableTable extends DocumentsTable
    with drift.TableInfo<$DocumentsTableTable, DocumentsTableData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTableTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta =
      const drift.VerificationMeta('id');
  @override
  late final drift.GeneratedColumn<String> id = drift.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _userIdMeta =
      const drift.VerificationMeta('userId');
  @override
  late final drift.GeneratedColumn<String> userId =
      drift.GeneratedColumn<String>('user_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _nameMeta =
      const drift.VerificationMeta('name');
  @override
  late final drift.GeneratedColumn<String> name = drift.GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _typeMeta =
      const drift.VerificationMeta('type');
  @override
  late final drift.GeneratedColumn<String> type = drift.GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _storagePathMeta =
      const drift.VerificationMeta('storagePath');
  @override
  late final drift.GeneratedColumn<String> storagePath =
      drift.GeneratedColumn<String>('storage_path', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _sizeBytesMeta =
      const drift.VerificationMeta('sizeBytes');
  @override
  late final drift.GeneratedColumn<int> sizeBytes = drift.GeneratedColumn<int>(
      'size_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const drift.VerificationMeta _createdAtMeta =
      const drift.VerificationMeta('createdAt');
  @override
  late final drift.GeneratedColumn<DateTime> createdAt =
      drift.GeneratedColumn<DateTime>('created_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: drift.currentDateAndTime);
  @override
  List<drift.GeneratedColumn> get $columns =>
      [id, userId, name, type, storagePath, sizeBytes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents_table';
  @override
  drift.VerificationContext validateIntegrity(
      drift.Insertable<DocumentsTableData> instance,
      {bool isInserting = false}) {
    final context = drift.VerificationContext();
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
  Set<drift.GeneratedColumn> get $primaryKey => {id};
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

class DocumentsTableData extends drift.DataClass
    implements drift.Insertable<DocumentsTableData> {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<String>(id);
    map['user_id'] = drift.Variable<String>(userId);
    map['name'] = drift.Variable<String>(name);
    map['type'] = drift.Variable<String>(type);
    map['storage_path'] = drift.Variable<String>(storagePath);
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = drift.Variable<int>(sizeBytes);
    }
    map['created_at'] = drift.Variable<DateTime>(createdAt);
    return map;
  }

  DocumentsTableCompanion toCompanion(bool nullToAbsent) {
    return DocumentsTableCompanion(
      id: drift.Value(id),
      userId: drift.Value(userId),
      name: drift.Value(name),
      type: drift.Value(type),
      storagePath: drift.Value(storagePath),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(sizeBytes),
      createdAt: drift.Value(createdAt),
    );
  }

  factory DocumentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
          drift.Value<int?> sizeBytes = const drift.Value.absent(),
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

class DocumentsTableCompanion
    extends drift.UpdateCompanion<DocumentsTableData> {
  final drift.Value<String> id;
  final drift.Value<String> userId;
  final drift.Value<String> name;
  final drift.Value<String> type;
  final drift.Value<String> storagePath;
  final drift.Value<int?> sizeBytes;
  final drift.Value<DateTime> createdAt;
  final drift.Value<int> rowid;
  const DocumentsTableCompanion({
    this.id = const drift.Value.absent(),
    this.userId = const drift.Value.absent(),
    this.name = const drift.Value.absent(),
    this.type = const drift.Value.absent(),
    this.storagePath = const drift.Value.absent(),
    this.sizeBytes = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  DocumentsTableCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String type,
    required String storagePath,
    this.sizeBytes = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  })  : id = drift.Value(id),
        userId = drift.Value(userId),
        name = drift.Value(name),
        type = drift.Value(type),
        storagePath = drift.Value(storagePath);
  static drift.Insertable<DocumentsTableData> custom({
    drift.Expression<String>? id,
    drift.Expression<String>? userId,
    drift.Expression<String>? name,
    drift.Expression<String>? type,
    drift.Expression<String>? storagePath,
    drift.Expression<int>? sizeBytes,
    drift.Expression<DateTime>? createdAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
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
      {drift.Value<String>? id,
      drift.Value<String>? userId,
      drift.Value<String>? name,
      drift.Value<String>? type,
      drift.Value<String>? storagePath,
      drift.Value<int?>? sizeBytes,
      drift.Value<DateTime>? createdAt,
      drift.Value<int>? rowid}) {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = drift.Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = drift.Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = drift.Variable<String>(type.value);
    }
    if (storagePath.present) {
      map['storage_path'] = drift.Variable<String>(storagePath.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = drift.Variable<int>(sizeBytes.value);
    }
    if (createdAt.present) {
      map['created_at'] = drift.Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
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
    with drift.TableInfo<$ScanReportsTableTable, ScanReportsTableData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanReportsTableTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta =
      const drift.VerificationMeta('id');
  @override
  late final drift.GeneratedColumn<String> id = drift.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _documentIdMeta =
      const drift.VerificationMeta('documentId');
  @override
  late final drift.GeneratedColumn<String> documentId =
      drift.GeneratedColumn<String>('document_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _userIdMeta =
      const drift.VerificationMeta('userId');
  @override
  late final drift.GeneratedColumn<String> userId =
      drift.GeneratedColumn<String>('user_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _similarityPctMeta =
      const drift.VerificationMeta('similarityPct');
  @override
  late final drift.GeneratedColumn<double> similarityPct =
      drift.GeneratedColumn<double>('similarity_pct', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const drift.VerificationMeta _statusMeta =
      const drift.VerificationMeta('status');
  @override
  late final drift.GeneratedColumn<String> status =
      drift.GeneratedColumn<String>('status', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _sourcesJsonMeta =
      const drift.VerificationMeta('sourcesJson');
  @override
  late final drift.GeneratedColumn<String> sourcesJson =
      drift.GeneratedColumn<String>('sources_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const drift.VerificationMeta _reportPdfUrlMeta =
      const drift.VerificationMeta('reportPdfUrl');
  @override
  late final drift.GeneratedColumn<String> reportPdfUrl =
      drift.GeneratedColumn<String>('report_pdf_url', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const drift.VerificationMeta _createdAtMeta =
      const drift.VerificationMeta('createdAt');
  @override
  late final drift.GeneratedColumn<DateTime> createdAt =
      drift.GeneratedColumn<DateTime>('created_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<drift.GeneratedColumn> get $columns => [
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
  drift.VerificationContext validateIntegrity(
      drift.Insertable<ScanReportsTableData> instance,
      {bool isInserting = false}) {
    final context = drift.VerificationContext();
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
  Set<drift.GeneratedColumn> get $primaryKey => {id};
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

class ScanReportsTableData extends drift.DataClass
    implements drift.Insertable<ScanReportsTableData> {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<String>(id);
    map['document_id'] = drift.Variable<String>(documentId);
    map['user_id'] = drift.Variable<String>(userId);
    if (!nullToAbsent || similarityPct != null) {
      map['similarity_pct'] = drift.Variable<double>(similarityPct);
    }
    map['status'] = drift.Variable<String>(status);
    if (!nullToAbsent || sourcesJson != null) {
      map['sources_json'] = drift.Variable<String>(sourcesJson);
    }
    if (!nullToAbsent || reportPdfUrl != null) {
      map['report_pdf_url'] = drift.Variable<String>(reportPdfUrl);
    }
    map['created_at'] = drift.Variable<DateTime>(createdAt);
    return map;
  }

  ScanReportsTableCompanion toCompanion(bool nullToAbsent) {
    return ScanReportsTableCompanion(
      id: drift.Value(id),
      documentId: drift.Value(documentId),
      userId: drift.Value(userId),
      similarityPct: similarityPct == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(similarityPct),
      status: drift.Value(status),
      sourcesJson: sourcesJson == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(sourcesJson),
      reportPdfUrl: reportPdfUrl == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(reportPdfUrl),
      createdAt: drift.Value(createdAt),
    );
  }

  factory ScanReportsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
          drift.Value<double?> similarityPct = const drift.Value.absent(),
          String? status,
          drift.Value<String?> sourcesJson = const drift.Value.absent(),
          drift.Value<String?> reportPdfUrl = const drift.Value.absent(),
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

class ScanReportsTableCompanion
    extends drift.UpdateCompanion<ScanReportsTableData> {
  final drift.Value<String> id;
  final drift.Value<String> documentId;
  final drift.Value<String> userId;
  final drift.Value<double?> similarityPct;
  final drift.Value<String> status;
  final drift.Value<String?> sourcesJson;
  final drift.Value<String?> reportPdfUrl;
  final drift.Value<DateTime> createdAt;
  final drift.Value<int> rowid;
  const ScanReportsTableCompanion({
    this.id = const drift.Value.absent(),
    this.documentId = const drift.Value.absent(),
    this.userId = const drift.Value.absent(),
    this.similarityPct = const drift.Value.absent(),
    this.status = const drift.Value.absent(),
    this.sourcesJson = const drift.Value.absent(),
    this.reportPdfUrl = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  ScanReportsTableCompanion.insert({
    required String id,
    required String documentId,
    required String userId,
    this.similarityPct = const drift.Value.absent(),
    required String status,
    this.sourcesJson = const drift.Value.absent(),
    this.reportPdfUrl = const drift.Value.absent(),
    required DateTime createdAt,
    this.rowid = const drift.Value.absent(),
  })  : id = drift.Value(id),
        documentId = drift.Value(documentId),
        userId = drift.Value(userId),
        status = drift.Value(status),
        createdAt = drift.Value(createdAt);
  static drift.Insertable<ScanReportsTableData> custom({
    drift.Expression<String>? id,
    drift.Expression<String>? documentId,
    drift.Expression<String>? userId,
    drift.Expression<double>? similarityPct,
    drift.Expression<String>? status,
    drift.Expression<String>? sourcesJson,
    drift.Expression<String>? reportPdfUrl,
    drift.Expression<DateTime>? createdAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
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
      {drift.Value<String>? id,
      drift.Value<String>? documentId,
      drift.Value<String>? userId,
      drift.Value<double?>? similarityPct,
      drift.Value<String>? status,
      drift.Value<String?>? sourcesJson,
      drift.Value<String?>? reportPdfUrl,
      drift.Value<DateTime>? createdAt,
      drift.Value<int>? rowid}) {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = drift.Variable<String>(documentId.value);
    }
    if (userId.present) {
      map['user_id'] = drift.Variable<String>(userId.value);
    }
    if (similarityPct.present) {
      map['similarity_pct'] = drift.Variable<double>(similarityPct.value);
    }
    if (status.present) {
      map['status'] = drift.Variable<String>(status.value);
    }
    if (sourcesJson.present) {
      map['sources_json'] = drift.Variable<String>(sourcesJson.value);
    }
    if (reportPdfUrl.present) {
      map['report_pdf_url'] = drift.Variable<String>(reportPdfUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = drift.Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
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
    with drift.TableInfo<$TranslationsTableTable, TranslationsTableData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationsTableTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta =
      const drift.VerificationMeta('id');
  @override
  late final drift.GeneratedColumn<String> id = drift.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _userIdMeta =
      const drift.VerificationMeta('userId');
  @override
  late final drift.GeneratedColumn<String> userId =
      drift.GeneratedColumn<String>('user_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _documentIdMeta =
      const drift.VerificationMeta('documentId');
  @override
  late final drift.GeneratedColumn<String> documentId =
      drift.GeneratedColumn<String>('document_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const drift.VerificationMeta _sourceLangMeta =
      const drift.VerificationMeta('sourceLang');
  @override
  late final drift.GeneratedColumn<String> sourceLang =
      drift.GeneratedColumn<String>('source_lang', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _targetLangMeta =
      const drift.VerificationMeta('targetLang');
  @override
  late final drift.GeneratedColumn<String> targetLang =
      drift.GeneratedColumn<String>('target_lang', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _inputTextMeta =
      const drift.VerificationMeta('inputText');
  @override
  late final drift.GeneratedColumn<String> inputText =
      drift.GeneratedColumn<String>('input_text', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _outputTextMeta =
      const drift.VerificationMeta('outputText');
  @override
  late final drift.GeneratedColumn<String> outputText =
      drift.GeneratedColumn<String>('output_text', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _createdAtMeta =
      const drift.VerificationMeta('createdAt');
  @override
  late final drift.GeneratedColumn<DateTime> createdAt =
      drift.GeneratedColumn<DateTime>('created_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<drift.GeneratedColumn> get $columns => [
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
  drift.VerificationContext validateIntegrity(
      drift.Insertable<TranslationsTableData> instance,
      {bool isInserting = false}) {
    final context = drift.VerificationContext();
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
  Set<drift.GeneratedColumn> get $primaryKey => {id};
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

class TranslationsTableData extends drift.DataClass
    implements drift.Insertable<TranslationsTableData> {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<String>(id);
    map['user_id'] = drift.Variable<String>(userId);
    if (!nullToAbsent || documentId != null) {
      map['document_id'] = drift.Variable<String>(documentId);
    }
    map['source_lang'] = drift.Variable<String>(sourceLang);
    map['target_lang'] = drift.Variable<String>(targetLang);
    map['input_text'] = drift.Variable<String>(inputText);
    map['output_text'] = drift.Variable<String>(outputText);
    map['created_at'] = drift.Variable<DateTime>(createdAt);
    return map;
  }

  TranslationsTableCompanion toCompanion(bool nullToAbsent) {
    return TranslationsTableCompanion(
      id: drift.Value(id),
      userId: drift.Value(userId),
      documentId: documentId == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(documentId),
      sourceLang: drift.Value(sourceLang),
      targetLang: drift.Value(targetLang),
      inputText: drift.Value(inputText),
      outputText: drift.Value(outputText),
      createdAt: drift.Value(createdAt),
    );
  }

  factory TranslationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
          drift.Value<String?> documentId = const drift.Value.absent(),
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
    extends drift.UpdateCompanion<TranslationsTableData> {
  final drift.Value<String> id;
  final drift.Value<String> userId;
  final drift.Value<String?> documentId;
  final drift.Value<String> sourceLang;
  final drift.Value<String> targetLang;
  final drift.Value<String> inputText;
  final drift.Value<String> outputText;
  final drift.Value<DateTime> createdAt;
  final drift.Value<int> rowid;
  const TranslationsTableCompanion({
    this.id = const drift.Value.absent(),
    this.userId = const drift.Value.absent(),
    this.documentId = const drift.Value.absent(),
    this.sourceLang = const drift.Value.absent(),
    this.targetLang = const drift.Value.absent(),
    this.inputText = const drift.Value.absent(),
    this.outputText = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  TranslationsTableCompanion.insert({
    required String id,
    required String userId,
    this.documentId = const drift.Value.absent(),
    required String sourceLang,
    required String targetLang,
    required String inputText,
    required String outputText,
    required DateTime createdAt,
    this.rowid = const drift.Value.absent(),
  })  : id = drift.Value(id),
        userId = drift.Value(userId),
        sourceLang = drift.Value(sourceLang),
        targetLang = drift.Value(targetLang),
        inputText = drift.Value(inputText),
        outputText = drift.Value(outputText),
        createdAt = drift.Value(createdAt);
  static drift.Insertable<TranslationsTableData> custom({
    drift.Expression<String>? id,
    drift.Expression<String>? userId,
    drift.Expression<String>? documentId,
    drift.Expression<String>? sourceLang,
    drift.Expression<String>? targetLang,
    drift.Expression<String>? inputText,
    drift.Expression<String>? outputText,
    drift.Expression<DateTime>? createdAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
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
      {drift.Value<String>? id,
      drift.Value<String>? userId,
      drift.Value<String?>? documentId,
      drift.Value<String>? sourceLang,
      drift.Value<String>? targetLang,
      drift.Value<String>? inputText,
      drift.Value<String>? outputText,
      drift.Value<DateTime>? createdAt,
      drift.Value<int>? rowid}) {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = drift.Variable<String>(userId.value);
    }
    if (documentId.present) {
      map['document_id'] = drift.Variable<String>(documentId.value);
    }
    if (sourceLang.present) {
      map['source_lang'] = drift.Variable<String>(sourceLang.value);
    }
    if (targetLang.present) {
      map['target_lang'] = drift.Variable<String>(targetLang.value);
    }
    if (inputText.present) {
      map['input_text'] = drift.Variable<String>(inputText.value);
    }
    if (outputText.present) {
      map['output_text'] = drift.Variable<String>(outputText.value);
    }
    if (createdAt.present) {
      map['created_at'] = drift.Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
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
    with drift.TableInfo<$ConversionJobsTableTable, ConversionJobsTableData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversionJobsTableTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta =
      const drift.VerificationMeta('id');
  @override
  late final drift.GeneratedColumn<String> id = drift.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _documentIdMeta =
      const drift.VerificationMeta('documentId');
  @override
  late final drift.GeneratedColumn<String> documentId =
      drift.GeneratedColumn<String>('document_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _userIdMeta =
      const drift.VerificationMeta('userId');
  @override
  late final drift.GeneratedColumn<String> userId =
      drift.GeneratedColumn<String>('user_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _fromFormatMeta =
      const drift.VerificationMeta('fromFormat');
  @override
  late final drift.GeneratedColumn<String> fromFormat =
      drift.GeneratedColumn<String>('from_format', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _toFormatMeta =
      const drift.VerificationMeta('toFormat');
  @override
  late final drift.GeneratedColumn<String> toFormat =
      drift.GeneratedColumn<String>('to_format', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _statusMeta =
      const drift.VerificationMeta('status');
  @override
  late final drift.GeneratedColumn<String> status =
      drift.GeneratedColumn<String>('status', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _outputPathMeta =
      const drift.VerificationMeta('outputPath');
  @override
  late final drift.GeneratedColumn<String> outputPath =
      drift.GeneratedColumn<String>('output_path', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const drift.VerificationMeta _createdAtMeta =
      const drift.VerificationMeta('createdAt');
  @override
  late final drift.GeneratedColumn<DateTime> createdAt =
      drift.GeneratedColumn<DateTime>('created_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<drift.GeneratedColumn> get $columns => [
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
  drift.VerificationContext validateIntegrity(
      drift.Insertable<ConversionJobsTableData> instance,
      {bool isInserting = false}) {
    final context = drift.VerificationContext();
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
  Set<drift.GeneratedColumn> get $primaryKey => {id};
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

class ConversionJobsTableData extends drift.DataClass
    implements drift.Insertable<ConversionJobsTableData> {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<String>(id);
    map['document_id'] = drift.Variable<String>(documentId);
    map['user_id'] = drift.Variable<String>(userId);
    map['from_format'] = drift.Variable<String>(fromFormat);
    map['to_format'] = drift.Variable<String>(toFormat);
    map['status'] = drift.Variable<String>(status);
    if (!nullToAbsent || outputPath != null) {
      map['output_path'] = drift.Variable<String>(outputPath);
    }
    map['created_at'] = drift.Variable<DateTime>(createdAt);
    return map;
  }

  ConversionJobsTableCompanion toCompanion(bool nullToAbsent) {
    return ConversionJobsTableCompanion(
      id: drift.Value(id),
      documentId: drift.Value(documentId),
      userId: drift.Value(userId),
      fromFormat: drift.Value(fromFormat),
      toFormat: drift.Value(toFormat),
      status: drift.Value(status),
      outputPath: outputPath == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(outputPath),
      createdAt: drift.Value(createdAt),
    );
  }

  factory ConversionJobsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
          drift.Value<String?> outputPath = const drift.Value.absent(),
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
    extends drift.UpdateCompanion<ConversionJobsTableData> {
  final drift.Value<String> id;
  final drift.Value<String> documentId;
  final drift.Value<String> userId;
  final drift.Value<String> fromFormat;
  final drift.Value<String> toFormat;
  final drift.Value<String> status;
  final drift.Value<String?> outputPath;
  final drift.Value<DateTime> createdAt;
  final drift.Value<int> rowid;
  const ConversionJobsTableCompanion({
    this.id = const drift.Value.absent(),
    this.documentId = const drift.Value.absent(),
    this.userId = const drift.Value.absent(),
    this.fromFormat = const drift.Value.absent(),
    this.toFormat = const drift.Value.absent(),
    this.status = const drift.Value.absent(),
    this.outputPath = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  ConversionJobsTableCompanion.insert({
    required String id,
    required String documentId,
    required String userId,
    required String fromFormat,
    required String toFormat,
    required String status,
    this.outputPath = const drift.Value.absent(),
    required DateTime createdAt,
    this.rowid = const drift.Value.absent(),
  })  : id = drift.Value(id),
        documentId = drift.Value(documentId),
        userId = drift.Value(userId),
        fromFormat = drift.Value(fromFormat),
        toFormat = drift.Value(toFormat),
        status = drift.Value(status),
        createdAt = drift.Value(createdAt);
  static drift.Insertable<ConversionJobsTableData> custom({
    drift.Expression<String>? id,
    drift.Expression<String>? documentId,
    drift.Expression<String>? userId,
    drift.Expression<String>? fromFormat,
    drift.Expression<String>? toFormat,
    drift.Expression<String>? status,
    drift.Expression<String>? outputPath,
    drift.Expression<DateTime>? createdAt,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
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
      {drift.Value<String>? id,
      drift.Value<String>? documentId,
      drift.Value<String>? userId,
      drift.Value<String>? fromFormat,
      drift.Value<String>? toFormat,
      drift.Value<String>? status,
      drift.Value<String?>? outputPath,
      drift.Value<DateTime>? createdAt,
      drift.Value<int>? rowid}) {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = drift.Variable<String>(documentId.value);
    }
    if (userId.present) {
      map['user_id'] = drift.Variable<String>(userId.value);
    }
    if (fromFormat.present) {
      map['from_format'] = drift.Variable<String>(fromFormat.value);
    }
    if (toFormat.present) {
      map['to_format'] = drift.Variable<String>(toFormat.value);
    }
    if (status.present) {
      map['status'] = drift.Variable<String>(status.value);
    }
    if (outputPath.present) {
      map['output_path'] = drift.Variable<String>(outputPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = drift.Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
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

class $SyncQueueTableTable extends SyncQueueTable
    with drift.TableInfo<$SyncQueueTableTable, SyncQueueTableData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta =
      const drift.VerificationMeta('id');
  @override
  late final drift.GeneratedColumn<String> id = drift.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _actionMeta =
      const drift.VerificationMeta('action');
  @override
  late final drift.GeneratedColumn<String> action =
      drift.GeneratedColumn<String>('action', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _payloadMeta =
      const drift.VerificationMeta('payload');
  @override
  late final drift.GeneratedColumn<String> payload =
      drift.GeneratedColumn<String>('payload', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const drift.VerificationMeta _createdAtMeta =
      const drift.VerificationMeta('createdAt');
  @override
  late final drift.GeneratedColumn<DateTime> createdAt =
      drift.GeneratedColumn<DateTime>('created_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: drift.currentDateAndTime);
  static const drift.VerificationMeta _retryCountMeta =
      const drift.VerificationMeta('retryCount');
  @override
  late final drift.GeneratedColumn<int> retryCount = drift.GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const drift.Constant(0));
  static const drift.VerificationMeta _statusMeta =
      const drift.VerificationMeta('status');
  @override
  late final drift.GeneratedColumn<String> status =
      drift.GeneratedColumn<String>('status', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const drift.Constant('pending'));
  @override
  List<drift.GeneratedColumn> get $columns =>
      [id, action, payload, createdAt, retryCount, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_table';
  @override
  drift.VerificationContext validateIntegrity(
      drift.Insertable<SyncQueueTableData> instance,
      {bool isInserting = false}) {
    final context = drift.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueTableData extends drift.DataClass
    implements drift.Insertable<SyncQueueTableData> {
  final String id;
  final String action;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final String status;
  const SyncQueueTableData(
      {required this.id,
      required this.action,
      required this.payload,
      required this.createdAt,
      required this.retryCount,
      required this.status});
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<String>(id);
    map['action'] = drift.Variable<String>(action);
    map['payload'] = drift.Variable<String>(payload);
    map['created_at'] = drift.Variable<DateTime>(createdAt);
    map['retry_count'] = drift.Variable<int>(retryCount);
    map['status'] = drift.Variable<String>(status);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: drift.Value(id),
      action: drift.Value(action),
      payload: drift.Value(payload),
      createdAt: drift.Value(createdAt),
      retryCount: drift.Value(retryCount),
      status: drift.Value(status),
    );
  }

  factory SyncQueueTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return SyncQueueTableData(
      id: serializer.fromJson<String>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
    };
  }

  SyncQueueTableData copyWith(
          {String? id,
          String? action,
          String? payload,
          DateTime? createdAt,
          int? retryCount,
          String? status}) =>
      SyncQueueTableData(
        id: id ?? this.id,
        action: action ?? this.action,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
        status: status ?? this.status,
      );
  SyncQueueTableData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableData(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, action, payload, createdAt, retryCount, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueTableData &&
          other.id == this.id &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.status == this.status);
}

class SyncQueueTableCompanion
    extends drift.UpdateCompanion<SyncQueueTableData> {
  final drift.Value<String> id;
  final drift.Value<String> action;
  final drift.Value<String> payload;
  final drift.Value<DateTime> createdAt;
  final drift.Value<int> retryCount;
  final drift.Value<String> status;
  final drift.Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const drift.Value.absent(),
    this.action = const drift.Value.absent(),
    this.payload = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.retryCount = const drift.Value.absent(),
    this.status = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    required String id,
    required String action,
    required String payload,
    this.createdAt = const drift.Value.absent(),
    this.retryCount = const drift.Value.absent(),
    this.status = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  })  : id = drift.Value(id),
        action = drift.Value(action),
        payload = drift.Value(payload);
  static drift.Insertable<SyncQueueTableData> custom({
    drift.Expression<String>? id,
    drift.Expression<String>? action,
    drift.Expression<String>? payload,
    drift.Expression<DateTime>? createdAt,
    drift.Expression<int>? retryCount,
    drift.Expression<String>? status,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith(
      {drift.Value<String>? id,
      drift.Value<String>? action,
      drift.Value<String>? payload,
      drift.Value<DateTime>? createdAt,
      drift.Value<int>? retryCount,
      drift.Value<String>? status,
      drift.Value<int>? rowid}) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<String>(id.value);
    }
    if (action.present) {
      map['action'] = drift.Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = drift.Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = drift.Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = drift.Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = drift.Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends drift.GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DocumentsTableTable documentsTable = $DocumentsTableTable(this);
  late final $ScanReportsTableTable scanReportsTable =
      $ScanReportsTableTable(this);
  late final $TranslationsTableTable translationsTable =
      $TranslationsTableTable(this);
  late final $ConversionJobsTableTable conversionJobsTable =
      $ConversionJobsTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final DocumentsDao documentsDao = DocumentsDao(this as AppDatabase);
  late final ScanReportsDao scanReportsDao =
      ScanReportsDao(this as AppDatabase);
  late final TranslationsDao translationsDao =
      TranslationsDao(this as AppDatabase);
  @override
  Iterable<drift.TableInfo<drift.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<drift.TableInfo<drift.Table, Object?>>();
  @override
  List<drift.DatabaseSchemaEntity> get allSchemaEntities => [
        documentsTable,
        scanReportsTable,
        translationsTable,
        conversionJobsTable,
        syncQueueTable
      ];
}

typedef $$DocumentsTableTableCreateCompanionBuilder = DocumentsTableCompanion
    Function({
  required String id,
  required String userId,
  required String name,
  required String type,
  required String storagePath,
  drift.Value<int?> sizeBytes,
  drift.Value<DateTime> createdAt,
  drift.Value<int> rowid,
});
typedef $$DocumentsTableTableUpdateCompanionBuilder = DocumentsTableCompanion
    Function({
  drift.Value<String> id,
  drift.Value<String> userId,
  drift.Value<String> name,
  drift.Value<String> type,
  drift.Value<String> storagePath,
  drift.Value<int?> sizeBytes,
  drift.Value<DateTime> createdAt,
  drift.Value<int> rowid,
});

class $$DocumentsTableTableFilterComposer
    extends drift.Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get storagePath => $composableBuilder(
      column: $table.storagePath,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnFilters(column));
}

class $$DocumentsTableTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get storagePath => $composableBuilder(
      column: $table.storagePath,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnOrderings(column));
}

class $$DocumentsTableTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  drift.GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  drift.GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  drift.GeneratedColumn<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => column);

  drift.GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  drift.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DocumentsTableTableTableManager extends drift.RootTableManager<
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
      drift
      .BaseReferences<_$AppDatabase, $DocumentsTableTable, DocumentsTableData>
    ),
    DocumentsTableData,
    drift.PrefetchHooks Function()> {
  $$DocumentsTableTableTableManager(
      _$AppDatabase db, $DocumentsTableTable table)
      : super(drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            drift.Value<String> id = const drift.Value.absent(),
            drift.Value<String> userId = const drift.Value.absent(),
            drift.Value<String> name = const drift.Value.absent(),
            drift.Value<String> type = const drift.Value.absent(),
            drift.Value<String> storagePath = const drift.Value.absent(),
            drift.Value<int?> sizeBytes = const drift.Value.absent(),
            drift.Value<DateTime> createdAt = const drift.Value.absent(),
            drift.Value<int> rowid = const drift.Value.absent(),
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
            drift.Value<int?> sizeBytes = const drift.Value.absent(),
            drift.Value<DateTime> createdAt = const drift.Value.absent(),
            drift.Value<int> rowid = const drift.Value.absent(),
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
              .map((e) =>
                  (e.readTable(table), drift.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentsTableTableProcessedTableManager
    = drift.ProcessedTableManager<
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
          drift.BaseReferences<_$AppDatabase, $DocumentsTableTable,
              DocumentsTableData>
        ),
        DocumentsTableData,
        drift.PrefetchHooks Function()>;
typedef $$ScanReportsTableTableCreateCompanionBuilder
    = ScanReportsTableCompanion Function({
  required String id,
  required String documentId,
  required String userId,
  drift.Value<double?> similarityPct,
  required String status,
  drift.Value<String?> sourcesJson,
  drift.Value<String?> reportPdfUrl,
  required DateTime createdAt,
  drift.Value<int> rowid,
});
typedef $$ScanReportsTableTableUpdateCompanionBuilder
    = ScanReportsTableCompanion Function({
  drift.Value<String> id,
  drift.Value<String> documentId,
  drift.Value<String> userId,
  drift.Value<double?> similarityPct,
  drift.Value<String> status,
  drift.Value<String?> sourcesJson,
  drift.Value<String?> reportPdfUrl,
  drift.Value<DateTime> createdAt,
  drift.Value<int> rowid,
});

class $$ScanReportsTableTableFilterComposer
    extends drift.Composer<_$AppDatabase, $ScanReportsTableTable> {
  $$ScanReportsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get documentId => $composableBuilder(
      column: $table.documentId,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<double> get similarityPct => $composableBuilder(
      column: $table.similarityPct,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get reportPdfUrl => $composableBuilder(
      column: $table.reportPdfUrl,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnFilters(column));
}

class $$ScanReportsTableTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $ScanReportsTableTable> {
  $$ScanReportsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get documentId => $composableBuilder(
      column: $table.documentId,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<double> get similarityPct => $composableBuilder(
      column: $table.similarityPct,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get reportPdfUrl => $composableBuilder(
      column: $table.reportPdfUrl,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnOrderings(column));
}

class $$ScanReportsTableTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $ScanReportsTableTable> {
  $$ScanReportsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  drift.GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  drift.GeneratedColumn<double> get similarityPct => $composableBuilder(
      column: $table.similarityPct, builder: (column) => column);

  drift.GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  drift.GeneratedColumn<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson, builder: (column) => column);

  drift.GeneratedColumn<String> get reportPdfUrl => $composableBuilder(
      column: $table.reportPdfUrl, builder: (column) => column);

  drift.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ScanReportsTableTableTableManager extends drift.RootTableManager<
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
      drift.BaseReferences<_$AppDatabase, $ScanReportsTableTable,
          ScanReportsTableData>
    ),
    ScanReportsTableData,
    drift.PrefetchHooks Function()> {
  $$ScanReportsTableTableTableManager(
      _$AppDatabase db, $ScanReportsTableTable table)
      : super(drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanReportsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanReportsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanReportsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            drift.Value<String> id = const drift.Value.absent(),
            drift.Value<String> documentId = const drift.Value.absent(),
            drift.Value<String> userId = const drift.Value.absent(),
            drift.Value<double?> similarityPct = const drift.Value.absent(),
            drift.Value<String> status = const drift.Value.absent(),
            drift.Value<String?> sourcesJson = const drift.Value.absent(),
            drift.Value<String?> reportPdfUrl = const drift.Value.absent(),
            drift.Value<DateTime> createdAt = const drift.Value.absent(),
            drift.Value<int> rowid = const drift.Value.absent(),
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
            drift.Value<double?> similarityPct = const drift.Value.absent(),
            required String status,
            drift.Value<String?> sourcesJson = const drift.Value.absent(),
            drift.Value<String?> reportPdfUrl = const drift.Value.absent(),
            required DateTime createdAt,
            drift.Value<int> rowid = const drift.Value.absent(),
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
              .map((e) =>
                  (e.readTable(table), drift.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScanReportsTableTableProcessedTableManager
    = drift.ProcessedTableManager<
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
          drift.BaseReferences<_$AppDatabase, $ScanReportsTableTable,
              ScanReportsTableData>
        ),
        ScanReportsTableData,
        drift.PrefetchHooks Function()>;
typedef $$TranslationsTableTableCreateCompanionBuilder
    = TranslationsTableCompanion Function({
  required String id,
  required String userId,
  drift.Value<String?> documentId,
  required String sourceLang,
  required String targetLang,
  required String inputText,
  required String outputText,
  required DateTime createdAt,
  drift.Value<int> rowid,
});
typedef $$TranslationsTableTableUpdateCompanionBuilder
    = TranslationsTableCompanion Function({
  drift.Value<String> id,
  drift.Value<String> userId,
  drift.Value<String?> documentId,
  drift.Value<String> sourceLang,
  drift.Value<String> targetLang,
  drift.Value<String> inputText,
  drift.Value<String> outputText,
  drift.Value<DateTime> createdAt,
  drift.Value<int> rowid,
});

class $$TranslationsTableTableFilterComposer
    extends drift.Composer<_$AppDatabase, $TranslationsTableTable> {
  $$TranslationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get documentId => $composableBuilder(
      column: $table.documentId,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get targetLang => $composableBuilder(
      column: $table.targetLang,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get inputText => $composableBuilder(
      column: $table.inputText,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get outputText => $composableBuilder(
      column: $table.outputText,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnFilters(column));
}

class $$TranslationsTableTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $TranslationsTableTable> {
  $$TranslationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get documentId => $composableBuilder(
      column: $table.documentId,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get targetLang => $composableBuilder(
      column: $table.targetLang,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get inputText => $composableBuilder(
      column: $table.inputText,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get outputText => $composableBuilder(
      column: $table.outputText,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnOrderings(column));
}

class $$TranslationsTableTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $TranslationsTableTable> {
  $$TranslationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  drift.GeneratedColumn<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  drift.GeneratedColumn<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => column);

  drift.GeneratedColumn<String> get targetLang => $composableBuilder(
      column: $table.targetLang, builder: (column) => column);

  drift.GeneratedColumn<String> get inputText =>
      $composableBuilder(column: $table.inputText, builder: (column) => column);

  drift.GeneratedColumn<String> get outputText => $composableBuilder(
      column: $table.outputText, builder: (column) => column);

  drift.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TranslationsTableTableTableManager extends drift.RootTableManager<
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
      drift.BaseReferences<_$AppDatabase, $TranslationsTableTable,
          TranslationsTableData>
    ),
    TranslationsTableData,
    drift.PrefetchHooks Function()> {
  $$TranslationsTableTableTableManager(
      _$AppDatabase db, $TranslationsTableTable table)
      : super(drift.TableManagerState(
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
            drift.Value<String> id = const drift.Value.absent(),
            drift.Value<String> userId = const drift.Value.absent(),
            drift.Value<String?> documentId = const drift.Value.absent(),
            drift.Value<String> sourceLang = const drift.Value.absent(),
            drift.Value<String> targetLang = const drift.Value.absent(),
            drift.Value<String> inputText = const drift.Value.absent(),
            drift.Value<String> outputText = const drift.Value.absent(),
            drift.Value<DateTime> createdAt = const drift.Value.absent(),
            drift.Value<int> rowid = const drift.Value.absent(),
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
            drift.Value<String?> documentId = const drift.Value.absent(),
            required String sourceLang,
            required String targetLang,
            required String inputText,
            required String outputText,
            required DateTime createdAt,
            drift.Value<int> rowid = const drift.Value.absent(),
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
              .map((e) =>
                  (e.readTable(table), drift.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TranslationsTableTableProcessedTableManager
    = drift.ProcessedTableManager<
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
          drift.BaseReferences<_$AppDatabase, $TranslationsTableTable,
              TranslationsTableData>
        ),
        TranslationsTableData,
        drift.PrefetchHooks Function()>;
typedef $$ConversionJobsTableTableCreateCompanionBuilder
    = ConversionJobsTableCompanion Function({
  required String id,
  required String documentId,
  required String userId,
  required String fromFormat,
  required String toFormat,
  required String status,
  drift.Value<String?> outputPath,
  required DateTime createdAt,
  drift.Value<int> rowid,
});
typedef $$ConversionJobsTableTableUpdateCompanionBuilder
    = ConversionJobsTableCompanion Function({
  drift.Value<String> id,
  drift.Value<String> documentId,
  drift.Value<String> userId,
  drift.Value<String> fromFormat,
  drift.Value<String> toFormat,
  drift.Value<String> status,
  drift.Value<String?> outputPath,
  drift.Value<DateTime> createdAt,
  drift.Value<int> rowid,
});

class $$ConversionJobsTableTableFilterComposer
    extends drift.Composer<_$AppDatabase, $ConversionJobsTableTable> {
  $$ConversionJobsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get documentId => $composableBuilder(
      column: $table.documentId,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get fromFormat => $composableBuilder(
      column: $table.fromFormat,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get toFormat => $composableBuilder(
      column: $table.toFormat,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get outputPath => $composableBuilder(
      column: $table.outputPath,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnFilters(column));
}

class $$ConversionJobsTableTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $ConversionJobsTableTable> {
  $$ConversionJobsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get documentId => $composableBuilder(
      column: $table.documentId,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get fromFormat => $composableBuilder(
      column: $table.fromFormat,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get toFormat => $composableBuilder(
      column: $table.toFormat,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get outputPath => $composableBuilder(
      column: $table.outputPath,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnOrderings(column));
}

class $$ConversionJobsTableTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $ConversionJobsTableTable> {
  $$ConversionJobsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  drift.GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  drift.GeneratedColumn<String> get fromFormat => $composableBuilder(
      column: $table.fromFormat, builder: (column) => column);

  drift.GeneratedColumn<String> get toFormat =>
      $composableBuilder(column: $table.toFormat, builder: (column) => column);

  drift.GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  drift.GeneratedColumn<String> get outputPath => $composableBuilder(
      column: $table.outputPath, builder: (column) => column);

  drift.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ConversionJobsTableTableTableManager extends drift.RootTableManager<
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
      drift.BaseReferences<_$AppDatabase, $ConversionJobsTableTable,
          ConversionJobsTableData>
    ),
    ConversionJobsTableData,
    drift.PrefetchHooks Function()> {
  $$ConversionJobsTableTableTableManager(
      _$AppDatabase db, $ConversionJobsTableTable table)
      : super(drift.TableManagerState(
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
            drift.Value<String> id = const drift.Value.absent(),
            drift.Value<String> documentId = const drift.Value.absent(),
            drift.Value<String> userId = const drift.Value.absent(),
            drift.Value<String> fromFormat = const drift.Value.absent(),
            drift.Value<String> toFormat = const drift.Value.absent(),
            drift.Value<String> status = const drift.Value.absent(),
            drift.Value<String?> outputPath = const drift.Value.absent(),
            drift.Value<DateTime> createdAt = const drift.Value.absent(),
            drift.Value<int> rowid = const drift.Value.absent(),
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
            drift.Value<String?> outputPath = const drift.Value.absent(),
            required DateTime createdAt,
            drift.Value<int> rowid = const drift.Value.absent(),
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
              .map((e) =>
                  (e.readTable(table), drift.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConversionJobsTableTableProcessedTableManager
    = drift.ProcessedTableManager<
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
          drift.BaseReferences<_$AppDatabase, $ConversionJobsTableTable,
              ConversionJobsTableData>
        ),
        ConversionJobsTableData,
        drift.PrefetchHooks Function()>;
typedef $$SyncQueueTableTableCreateCompanionBuilder = SyncQueueTableCompanion
    Function({
  required String id,
  required String action,
  required String payload,
  drift.Value<DateTime> createdAt,
  drift.Value<int> retryCount,
  drift.Value<String> status,
  drift.Value<int> rowid,
});
typedef $$SyncQueueTableTableUpdateCompanionBuilder = SyncQueueTableCompanion
    Function({
  drift.Value<String> id,
  drift.Value<String> action,
  drift.Value<String> payload,
  drift.Value<DateTime> createdAt,
  drift.Value<int> retryCount,
  drift.Value<String> status,
  drift.Value<int> rowid,
});

class $$SyncQueueTableTableFilterComposer
    extends drift.Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount,
      builder: (column) => drift.ColumnFilters(column));

  drift.ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => drift.ColumnFilters(column));
}

class $$SyncQueueTableTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount,
      builder: (column) => drift.ColumnOrderings(column));

  drift.ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status,
      builder: (column) => drift.ColumnOrderings(column));
}

class $$SyncQueueTableTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  drift.GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  drift.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  drift.GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  drift.GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager extends drift.RootTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      drift
      .BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    drift.PrefetchHooks Function()> {
  $$SyncQueueTableTableTableManager(
      _$AppDatabase db, $SyncQueueTableTable table)
      : super(drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            drift.Value<String> id = const drift.Value.absent(),
            drift.Value<String> action = const drift.Value.absent(),
            drift.Value<String> payload = const drift.Value.absent(),
            drift.Value<DateTime> createdAt = const drift.Value.absent(),
            drift.Value<int> retryCount = const drift.Value.absent(),
            drift.Value<String> status = const drift.Value.absent(),
            drift.Value<int> rowid = const drift.Value.absent(),
          }) =>
              SyncQueueTableCompanion(
            id: id,
            action: action,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String action,
            required String payload,
            drift.Value<DateTime> createdAt = const drift.Value.absent(),
            drift.Value<int> retryCount = const drift.Value.absent(),
            drift.Value<String> status = const drift.Value.absent(),
            drift.Value<int> rowid = const drift.Value.absent(),
          }) =>
              SyncQueueTableCompanion.insert(
            id: id,
            action: action,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), drift.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableTableProcessedTableManager
    = drift.ProcessedTableManager<
        _$AppDatabase,
        $SyncQueueTableTable,
        SyncQueueTableData,
        $$SyncQueueTableTableFilterComposer,
        $$SyncQueueTableTableOrderingComposer,
        $$SyncQueueTableTableAnnotationComposer,
        $$SyncQueueTableTableCreateCompanionBuilder,
        $$SyncQueueTableTableUpdateCompanionBuilder,
        (
          SyncQueueTableData,
          drift.BaseReferences<_$AppDatabase, $SyncQueueTableTable,
              SyncQueueTableData>
        ),
        SyncQueueTableData,
        drift.PrefetchHooks Function()>;

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
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
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
