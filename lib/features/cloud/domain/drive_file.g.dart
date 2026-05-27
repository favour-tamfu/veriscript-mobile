// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriveFileImpl _$$DriveFileImplFromJson(Map<String, dynamic> json) =>
    _$DriveFileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
      modifiedTime: DateTime.parse(json['modifiedTime'] as String),
      webViewLink: json['webViewLink'] as String?,
    );

Map<String, dynamic> _$$DriveFileImplToJson(_$DriveFileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mimeType': instance.mimeType,
      'sizeBytes': instance.sizeBytes,
      'modifiedTime': instance.modifiedTime.toIso8601String(),
      'webViewLink': instance.webViewLink,
    };
