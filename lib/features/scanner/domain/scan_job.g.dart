// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanJobImpl _$$ScanJobImplFromJson(Map<String, dynamic> json) =>
    _$ScanJobImpl(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      similarityPct: (json['similarityPct'] as num?)?.toDouble(),
      sources: (json['sources'] as List<dynamic>?)
          ?.map((e) => ScanSource.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportPdfUrl: json['reportPdfUrl'] as String?,
      externalScanId: json['externalScanId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ScanJobImplToJson(_$ScanJobImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'userId': instance.userId,
      'status': instance.status,
      'similarityPct': instance.similarityPct,
      'sources': instance.sources,
      'reportPdfUrl': instance.reportPdfUrl,
      'externalScanId': instance.externalScanId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$ScanSourceImpl _$$ScanSourceImplFromJson(Map<String, dynamic> json) =>
    _$ScanSourceImpl(
      url: json['url'] as String,
      title: json['title'] as String,
      matchedPercent: (json['matchedPercent'] as num).toDouble(),
      matchedWords: (json['matchedWords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ScanSourceImplToJson(_$ScanSourceImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'matchedPercent': instance.matchedPercent,
      'matchedWords': instance.matchedWords,
    };
