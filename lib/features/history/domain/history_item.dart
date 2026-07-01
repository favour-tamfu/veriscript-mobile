import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_item.freezed.dart';
part 'history_item.g.dart';

@freezed
class HistoryItem with _$HistoryItem {
  const factory HistoryItem({
    required String id,
    required String documentId,
    required String name,
    required String type,
    required String action,
    required String status,
    required DateTime createdAt,
    double? similarityPct,
    double? aiProbability,
    String? fromFormat,
    String? toFormat,
    String? outputPath,
    String? sourceLang,
    String? targetLang,
  }) = _HistoryItem;

  factory HistoryItem.fromJson(Map<String, dynamic> json) => _$HistoryItemFromJson(json);
}
