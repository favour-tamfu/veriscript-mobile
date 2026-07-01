import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Downloads [url] to a temporary file named [fileName] and opens it with the
/// device's default handler — avoiding a browser round-trip. Returns `null` on
/// success, or an error message on failure.
Future<String?> downloadAndOpenFile(String url, String fileName) async {
  try {
    final dir = await getTemporaryDirectory();
    final path = p.join(dir.path, fileName);
    await Dio().download(url, path);

    // Opening is best-effort; the download succeeding is what matters.
    await OpenFile.open(path);
    return null;
  } catch (e) {
    return e.toString();
  }
}
