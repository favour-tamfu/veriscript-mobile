import 'package:freezed_annotation/freezed_annotation.dart';

part 'drive_file.freezed.dart';
part 'drive_file.g.dart';

@freezed
class DriveFile with _$DriveFile {
  const factory DriveFile({
    required String id,
    required String name,
    required String mimeType,
    int? sizeBytes,
    required DateTime modifiedTime,
    String? webViewLink,
  }) = _DriveFile;

  factory DriveFile.fromJson(Map<String, dynamic> json) => _$DriveFileFromJson(json);
}
