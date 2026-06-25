import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/library_file.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepository(),
);

/// Stores files in an app-local "bucket": bytes go to <appDocs>/library/, and a
/// metadata index is kept per user in SharedPreferences.
class LibraryRepository {
  String _key(String userId) => 'library_$userId';

  Future<Directory> _libraryDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final libDir = Directory(p.join(dir.path, 'library'));
    if (!await libDir.exists()) {
      await libDir.create(recursive: true);
    }
    return libDir;
  }

  Future<List<LibraryFile>> list(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map((e) => LibraryFile.fromJson(e as Map<String, dynamic>))
          .where((f) => File(f.localPath).existsSync())
          .toList();
      items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveIndex(String userId, List<LibraryFile> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(userId),
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  /// Copies [source] into the library bucket and indexes it.
  Future<LibraryFile> save({
    required String userId,
    required File source,
    required String name,
    required String mimeType,
    required String origin,
  }) async {
    final libDir = await _libraryDir();
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final safeName = name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final destPath = p.join(libDir.path, '${id}_$safeName');
    await source.copy(destPath);
    final size = await File(destPath).length();

    final item = LibraryFile(
      id: id,
      name: name,
      localPath: destPath,
      mimeType: mimeType,
      sizeBytes: size,
      origin: origin,
      savedAt: DateTime.now(),
    );

    final items = await list(userId);
    await _saveIndex(userId, [item, ...items]);
    return item;
  }

  Future<void> delete(String userId, LibraryFile item) async {
    final file = File(item.localPath);
    if (await file.exists()) {
      await file.delete();
    }
    final items = await list(userId);
    await _saveIndex(userId, items.where((i) => i.id != item.id).toList());
  }
}
