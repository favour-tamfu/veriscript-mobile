// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScanJob _$ScanJobFromJson(Map<String, dynamic> json) {
  return _ScanJob.fromJson(json);
}

/// @nodoc
mixin _$ScanJob {
  String get id => throw _privateConstructorUsedError;
  String get documentId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double? get similarityPct => throw _privateConstructorUsedError;
  double? get aiProbability => throw _privateConstructorUsedError;
  List<ScanSource>? get sources => throw _privateConstructorUsedError;
  String? get reportPdfUrl => throw _privateConstructorUsedError;
  String? get externalScanId => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ScanJob to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanJobCopyWith<ScanJob> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanJobCopyWith<$Res> {
  factory $ScanJobCopyWith(ScanJob value, $Res Function(ScanJob) then) =
      _$ScanJobCopyWithImpl<$Res, ScanJob>;
  @useResult
  $Res call(
      {String id,
      String documentId,
      String userId,
      String status,
      double? similarityPct,
      double? aiProbability,
      List<ScanSource>? sources,
      String? reportPdfUrl,
      String? externalScanId,
      String? errorMessage,
      DateTime createdAt});
}

/// @nodoc
class _$ScanJobCopyWithImpl<$Res, $Val extends ScanJob>
    implements $ScanJobCopyWith<$Res> {
  _$ScanJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentId = null,
    Object? userId = null,
    Object? status = null,
    Object? similarityPct = freezed,
    Object? aiProbability = freezed,
    Object? sources = freezed,
    Object? reportPdfUrl = freezed,
    Object? externalScanId = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      similarityPct: freezed == similarityPct
          ? _value.similarityPct
          : similarityPct // ignore: cast_nullable_to_non_nullable
              as double?,
      aiProbability: freezed == aiProbability
          ? _value.aiProbability
          : aiProbability // ignore: cast_nullable_to_non_nullable
              as double?,
      sources: freezed == sources
          ? _value.sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<ScanSource>?,
      reportPdfUrl: freezed == reportPdfUrl
          ? _value.reportPdfUrl
          : reportPdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      externalScanId: freezed == externalScanId
          ? _value.externalScanId
          : externalScanId // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanJobImplCopyWith<$Res> implements $ScanJobCopyWith<$Res> {
  factory _$$ScanJobImplCopyWith(
          _$ScanJobImpl value, $Res Function(_$ScanJobImpl) then) =
      __$$ScanJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String documentId,
      String userId,
      String status,
      double? similarityPct,
      double? aiProbability,
      List<ScanSource>? sources,
      String? reportPdfUrl,
      String? externalScanId,
      String? errorMessage,
      DateTime createdAt});
}

/// @nodoc
class __$$ScanJobImplCopyWithImpl<$Res>
    extends _$ScanJobCopyWithImpl<$Res, _$ScanJobImpl>
    implements _$$ScanJobImplCopyWith<$Res> {
  __$$ScanJobImplCopyWithImpl(
      _$ScanJobImpl _value, $Res Function(_$ScanJobImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentId = null,
    Object? userId = null,
    Object? status = null,
    Object? similarityPct = freezed,
    Object? aiProbability = freezed,
    Object? sources = freezed,
    Object? reportPdfUrl = freezed,
    Object? externalScanId = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ScanJobImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      similarityPct: freezed == similarityPct
          ? _value.similarityPct
          : similarityPct // ignore: cast_nullable_to_non_nullable
              as double?,
      aiProbability: freezed == aiProbability
          ? _value.aiProbability
          : aiProbability // ignore: cast_nullable_to_non_nullable
              as double?,
      sources: freezed == sources
          ? _value._sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<ScanSource>?,
      reportPdfUrl: freezed == reportPdfUrl
          ? _value.reportPdfUrl
          : reportPdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      externalScanId: freezed == externalScanId
          ? _value.externalScanId
          : externalScanId // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanJobImpl implements _ScanJob {
  const _$ScanJobImpl(
      {required this.id,
      required this.documentId,
      required this.userId,
      required this.status,
      this.similarityPct,
      this.aiProbability,
      final List<ScanSource>? sources,
      this.reportPdfUrl,
      this.externalScanId,
      this.errorMessage,
      required this.createdAt})
      : _sources = sources;

  factory _$ScanJobImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanJobImplFromJson(json);

  @override
  final String id;
  @override
  final String documentId;
  @override
  final String userId;
  @override
  final String status;
  @override
  final double? similarityPct;
  @override
  final double? aiProbability;
  final List<ScanSource>? _sources;
  @override
  List<ScanSource>? get sources {
    final value = _sources;
    if (value == null) return null;
    if (_sources is EqualUnmodifiableListView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? reportPdfUrl;
  @override
  final String? externalScanId;
  @override
  final String? errorMessage;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ScanJob(id: $id, documentId: $documentId, userId: $userId, status: $status, similarityPct: $similarityPct, aiProbability: $aiProbability, sources: $sources, reportPdfUrl: $reportPdfUrl, externalScanId: $externalScanId, errorMessage: $errorMessage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanJobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.similarityPct, similarityPct) ||
                other.similarityPct == similarityPct) &&
            (identical(other.aiProbability, aiProbability) ||
                other.aiProbability == aiProbability) &&
            const DeepCollectionEquality().equals(other._sources, _sources) &&
            (identical(other.reportPdfUrl, reportPdfUrl) ||
                other.reportPdfUrl == reportPdfUrl) &&
            (identical(other.externalScanId, externalScanId) ||
                other.externalScanId == externalScanId) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      documentId,
      userId,
      status,
      similarityPct,
      aiProbability,
      const DeepCollectionEquality().hash(_sources),
      reportPdfUrl,
      externalScanId,
      errorMessage,
      createdAt);

  /// Create a copy of ScanJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanJobImplCopyWith<_$ScanJobImpl> get copyWith =>
      __$$ScanJobImplCopyWithImpl<_$ScanJobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanJobImplToJson(
      this,
    );
  }
}

abstract class _ScanJob implements ScanJob {
  const factory _ScanJob(
      {required final String id,
      required final String documentId,
      required final String userId,
      required final String status,
      final double? similarityPct,
      final double? aiProbability,
      final List<ScanSource>? sources,
      final String? reportPdfUrl,
      final String? externalScanId,
      final String? errorMessage,
      required final DateTime createdAt}) = _$ScanJobImpl;

  factory _ScanJob.fromJson(Map<String, dynamic> json) = _$ScanJobImpl.fromJson;

  @override
  String get id;
  @override
  String get documentId;
  @override
  String get userId;
  @override
  String get status;
  @override
  double? get similarityPct;
  @override
  double? get aiProbability;
  @override
  List<ScanSource>? get sources;
  @override
  String? get reportPdfUrl;
  @override
  String? get externalScanId;
  @override
  String? get errorMessage;
  @override
  DateTime get createdAt;

  /// Create a copy of ScanJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanJobImplCopyWith<_$ScanJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanSource _$ScanSourceFromJson(Map<String, dynamic> json) {
  return _ScanSource.fromJson(json);
}

/// @nodoc
mixin _$ScanSource {
  String get url => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get matchedPercent => throw _privateConstructorUsedError;
  int? get matchedWords => throw _privateConstructorUsedError;

  /// Serializes this ScanSource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanSourceCopyWith<ScanSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanSourceCopyWith<$Res> {
  factory $ScanSourceCopyWith(
          ScanSource value, $Res Function(ScanSource) then) =
      _$ScanSourceCopyWithImpl<$Res, ScanSource>;
  @useResult
  $Res call(
      {String url, String title, double matchedPercent, int? matchedWords});
}

/// @nodoc
class _$ScanSourceCopyWithImpl<$Res, $Val extends ScanSource>
    implements $ScanSourceCopyWith<$Res> {
  _$ScanSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? title = null,
    Object? matchedPercent = null,
    Object? matchedWords = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      matchedPercent: null == matchedPercent
          ? _value.matchedPercent
          : matchedPercent // ignore: cast_nullable_to_non_nullable
              as double,
      matchedWords: freezed == matchedWords
          ? _value.matchedWords
          : matchedWords // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanSourceImplCopyWith<$Res>
    implements $ScanSourceCopyWith<$Res> {
  factory _$$ScanSourceImplCopyWith(
          _$ScanSourceImpl value, $Res Function(_$ScanSourceImpl) then) =
      __$$ScanSourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url, String title, double matchedPercent, int? matchedWords});
}

/// @nodoc
class __$$ScanSourceImplCopyWithImpl<$Res>
    extends _$ScanSourceCopyWithImpl<$Res, _$ScanSourceImpl>
    implements _$$ScanSourceImplCopyWith<$Res> {
  __$$ScanSourceImplCopyWithImpl(
      _$ScanSourceImpl _value, $Res Function(_$ScanSourceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? title = null,
    Object? matchedPercent = null,
    Object? matchedWords = freezed,
  }) {
    return _then(_$ScanSourceImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      matchedPercent: null == matchedPercent
          ? _value.matchedPercent
          : matchedPercent // ignore: cast_nullable_to_non_nullable
              as double,
      matchedWords: freezed == matchedWords
          ? _value.matchedWords
          : matchedWords // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanSourceImpl implements _ScanSource {
  const _$ScanSourceImpl(
      {required this.url,
      required this.title,
      required this.matchedPercent,
      this.matchedWords});

  factory _$ScanSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanSourceImplFromJson(json);

  @override
  final String url;
  @override
  final String title;
  @override
  final double matchedPercent;
  @override
  final int? matchedWords;

  @override
  String toString() {
    return 'ScanSource(url: $url, title: $title, matchedPercent: $matchedPercent, matchedWords: $matchedWords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanSourceImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.matchedPercent, matchedPercent) ||
                other.matchedPercent == matchedPercent) &&
            (identical(other.matchedWords, matchedWords) ||
                other.matchedWords == matchedWords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, url, title, matchedPercent, matchedWords);

  /// Create a copy of ScanSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanSourceImplCopyWith<_$ScanSourceImpl> get copyWith =>
      __$$ScanSourceImplCopyWithImpl<_$ScanSourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanSourceImplToJson(
      this,
    );
  }
}

abstract class _ScanSource implements ScanSource {
  const factory _ScanSource(
      {required final String url,
      required final String title,
      required final double matchedPercent,
      final int? matchedWords}) = _$ScanSourceImpl;

  factory _ScanSource.fromJson(Map<String, dynamic> json) =
      _$ScanSourceImpl.fromJson;

  @override
  String get url;
  @override
  String get title;
  @override
  double get matchedPercent;
  @override
  int? get matchedWords;

  /// Create a copy of ScanSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanSourceImplCopyWith<_$ScanSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
