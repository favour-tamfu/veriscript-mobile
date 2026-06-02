// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryItemImpl _$$HistoryItemImplFromJson(Map<String, dynamic> json) =>
    _$HistoryItemImpl(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      action: json['action'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      similarityPct: (json['similarityPct'] as num?)?.toDouble(),
      aiProbability: (json['aiProbability'] as num?)?.toDouble(),
      fromFormat: json['fromFormat'] as String?,
      toFormat: json['toFormat'] as String?,
      outputPath: json['outputPath'] as String?,
      sourceLang: json['sourceLang'] as String?,
      targetLang: json['targetLang'] as String?,
    );

Map<String, dynamic> _$$HistoryItemImplToJson(_$HistoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'name': instance.name,
      'type': instance.type,
      'action': instance.action,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'similarityPct': instance.similarityPct,
      'aiProbability': instance.aiProbability,
      'fromFormat': instance.fromFormat,
      'toFormat': instance.toFormat,
      'outputPath': instance.outputPath,
      'sourceLang': instance.sourceLang,
      'targetLang': instance.targetLang,
    };
