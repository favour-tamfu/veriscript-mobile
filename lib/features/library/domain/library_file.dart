/// A file kept in the app's local "bucket"/library so it can be reused later
/// (e.g. imported from Google Drive, then translated). Metadata is indexed in
/// SharedPreferences; the bytes live in the app documents directory.
class LibraryFile {
  const LibraryFile({
    required this.id,
    required this.name,
    required this.localPath,
    required this.mimeType,
    required this.sizeBytes,
    required this.origin,
    required this.savedAt,
  });

  final String id;
  final String name;
  final String localPath;
  final String mimeType;
  final int sizeBytes;

  /// Where it came from: 'drive' | 'device'.
  final String origin;
  final DateTime savedAt;

  String get extension {
    final dot = name.lastIndexOf('.');
    return dot == -1 ? '' : name.substring(dot + 1).toLowerCase();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'localPath': localPath,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'origin': origin,
        'savedAt': savedAt.toIso8601String(),
      };

  factory LibraryFile.fromJson(Map<String, dynamic> json) => LibraryFile(
        id: json['id'] as String,
        name: json['name'] as String,
        localPath: json['localPath'] as String,
        mimeType: json['mimeType'] as String? ?? 'application/octet-stream',
        sizeBytes: json['sizeBytes'] as int? ?? 0,
        origin: json['origin'] as String? ?? 'device',
        savedAt:
            DateTime.tryParse(json['savedAt'] as String? ?? '') ?? DateTime.now(),
      );
}
