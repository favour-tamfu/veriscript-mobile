import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversion_job.freezed.dart';

@freezed
class ConversionJob with _$ConversionJob {
  const factory ConversionJob({
    required String id,
    required String documentId,
    required String userId,
    required String fromFormat,
    required String toFormat,
    required String status,
    String? outputPath,
    required DateTime createdAt,
  }) = _ConversionJob;
}
