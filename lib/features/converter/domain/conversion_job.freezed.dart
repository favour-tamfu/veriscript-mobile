// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversion_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConversionJob {
  String get id => throw _privateConstructorUsedError;
  String get documentId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get fromFormat => throw _privateConstructorUsedError;
  String get toFormat => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get outputPath => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of ConversionJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversionJobCopyWith<ConversionJob> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversionJobCopyWith<$Res> {
  factory $ConversionJobCopyWith(
          ConversionJob value, $Res Function(ConversionJob) then) =
      _$ConversionJobCopyWithImpl<$Res, ConversionJob>;
  @useResult
  $Res call(
      {String id,
      String documentId,
      String userId,
      String fromFormat,
      String toFormat,
      String status,
      String? outputPath,
      DateTime createdAt});
}

/// @nodoc
class _$ConversionJobCopyWithImpl<$Res, $Val extends ConversionJob>
    implements $ConversionJobCopyWith<$Res> {
  _$ConversionJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversionJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentId = null,
    Object? userId = null,
    Object? fromFormat = null,
    Object? toFormat = null,
    Object? status = null,
    Object? outputPath = freezed,
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
      fromFormat: null == fromFormat
          ? _value.fromFormat
          : fromFormat // ignore: cast_nullable_to_non_nullable
              as String,
      toFormat: null == toFormat
          ? _value.toFormat
          : toFormat // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      outputPath: freezed == outputPath
          ? _value.outputPath
          : outputPath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversionJobImplCopyWith<$Res>
    implements $ConversionJobCopyWith<$Res> {
  factory _$$ConversionJobImplCopyWith(
          _$ConversionJobImpl value, $Res Function(_$ConversionJobImpl) then) =
      __$$ConversionJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String documentId,
      String userId,
      String fromFormat,
      String toFormat,
      String status,
      String? outputPath,
      DateTime createdAt});
}

/// @nodoc
class __$$ConversionJobImplCopyWithImpl<$Res>
    extends _$ConversionJobCopyWithImpl<$Res, _$ConversionJobImpl>
    implements _$$ConversionJobImplCopyWith<$Res> {
  __$$ConversionJobImplCopyWithImpl(
      _$ConversionJobImpl _value, $Res Function(_$ConversionJobImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversionJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentId = null,
    Object? userId = null,
    Object? fromFormat = null,
    Object? toFormat = null,
    Object? status = null,
    Object? outputPath = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ConversionJobImpl(
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
      fromFormat: null == fromFormat
          ? _value.fromFormat
          : fromFormat // ignore: cast_nullable_to_non_nullable
              as String,
      toFormat: null == toFormat
          ? _value.toFormat
          : toFormat // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      outputPath: freezed == outputPath
          ? _value.outputPath
          : outputPath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ConversionJobImpl implements _ConversionJob {
  const _$ConversionJobImpl(
      {required this.id,
      required this.documentId,
      required this.userId,
      required this.fromFormat,
      required this.toFormat,
      required this.status,
      this.outputPath,
      required this.createdAt});

  @override
  final String id;
  @override
  final String documentId;
  @override
  final String userId;
  @override
  final String fromFormat;
  @override
  final String toFormat;
  @override
  final String status;
  @override
  final String? outputPath;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ConversionJob(id: $id, documentId: $documentId, userId: $userId, fromFormat: $fromFormat, toFormat: $toFormat, status: $status, outputPath: $outputPath, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversionJobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fromFormat, fromFormat) ||
                other.fromFormat == fromFormat) &&
            (identical(other.toFormat, toFormat) ||
                other.toFormat == toFormat) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.outputPath, outputPath) ||
                other.outputPath == outputPath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, documentId, userId,
      fromFormat, toFormat, status, outputPath, createdAt);

  /// Create a copy of ConversionJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversionJobImplCopyWith<_$ConversionJobImpl> get copyWith =>
      __$$ConversionJobImplCopyWithImpl<_$ConversionJobImpl>(this, _$identity);
}

abstract class _ConversionJob implements ConversionJob {
  const factory _ConversionJob(
      {required final String id,
      required final String documentId,
      required final String userId,
      required final String fromFormat,
      required final String toFormat,
      required final String status,
      final String? outputPath,
      required final DateTime createdAt}) = _$ConversionJobImpl;

  @override
  String get id;
  @override
  String get documentId;
  @override
  String get userId;
  @override
  String get fromFormat;
  @override
  String get toFormat;
  @override
  String get status;
  @override
  String? get outputPath;
  @override
  DateTime get createdAt;

  /// Create a copy of ConversionJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversionJobImplCopyWith<_$ConversionJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
