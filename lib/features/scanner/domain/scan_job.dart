import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_job.freezed.dart';
part 'scan_job.g.dart';

@freezed
class ScanJob with _$ScanJob {
  const factory ScanJob({
    required String id,
    required String documentId,
    required String userId,
    required String status,
    double? similarityPct,
    double? aiProbability,
    List<ScanSource>? sources,
    String? reportPdfUrl,
    String? externalScanId,
    String? errorMessage,
    required DateTime createdAt,
  }) = _ScanJob;

  factory ScanJob.fromJson(Map<String, dynamic> json) => _$ScanJobFromJson(json);
}

@freezed
class ScanSource with _$ScanSource {
  const factory ScanSource({
    required String url,
    required String title,
    required double matchedPercent,
    int? matchedWords,
  }) = _ScanSource;

  factory ScanSource.fromJson(Map<String, dynamic> json) => _$ScanSourceFromJson(json);
}
