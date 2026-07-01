import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../domain/drive_file.dart';

// TODO: DEVELOPER ACTION — add google-services.json to android/app/
// Download from Google Cloud Console → OAuth credentials → Android

final driveRepositoryProvider = Provider<DriveRepository>((ref) => DriveRepository());

class DriveRepository {
  static final _googleSignIn = GoogleSignIn(scopes: [
    'https://www.googleapis.com/auth/drive.readonly',
    'https://www.googleapis.com/auth/drive.file',
  ]);

  Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();

  Future<void> signOut() => _googleSignIn.signOut();

  bool get isSignedIn => _googleSignIn.currentUser != null;

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<List<DriveFile>> listFiles({String? folderId, String? pageToken}) async {
    final account = _googleSignIn.currentUser;
    if (account == null) return [];

    final headers = await account.authHeaders;
    final query = "mimeType='application/pdf' or "
        "mimeType='application/vnd.openxmlformats-officedocument.wordprocessingml.document' or "
        "mimeType='text/plain'";

    final params = <String, String>{
      'q': query,
      'fields': 'files(id,name,mimeType,size,modifiedTime,webViewLink)',
      'pageSize': '50',
      if (pageToken != null) 'pageToken': pageToken,
    };

    final uri = Uri.https('www.googleapis.com', '/drive/v3/files', params);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to list Drive files: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final files = data['files'] as List<dynamic>? ?? [];
    return files.map((f) => DriveFile.fromJson(f as Map<String, dynamic>)).toList();
  }

  Future<File> downloadFile(DriveFile driveFile) async {
    final account = _googleSignIn.currentUser;
    if (account == null) throw Exception('Not signed in');

    final headers = await account.authHeaders;
    final uri = Uri.https(
      'www.googleapis.com',
      '/drive/v3/files/${driveFile.id}',
      {'alt': 'media'},
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to download file: ${response.statusCode}');
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${driveFile.name}');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<String> uploadFile(File localFile, String fileName, String mimeType) async {
    final account = _googleSignIn.currentUser;
    if (account == null) throw Exception('Not signed in');

    final headers = await account.authHeaders;
    final bytes = await localFile.readAsBytes();

    final metadataJson = jsonEncode({'name': fileName});

    final uri = Uri.parse(
      'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
    );

    final boundary = 'veriscipt_upload_${DateTime.now().millisecondsSinceEpoch}';
    final body = '--$boundary\r\n'
        'Content-Type: application/json; charset=UTF-8\r\n\r\n'
        '$metadataJson\r\n'
        '--$boundary\r\n'
        'Content-Type: $mimeType\r\n\r\n';

    final bodyBytes = [...utf8.encode(body), ...bytes, ...utf8.encode('\r\n--$boundary--')];

    final response = await http.post(
      uri,
      headers: {
        ...headers,
        'Content-Type': 'multipart/related; boundary=$boundary',
      },
      body: bodyBytes,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Upload failed: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['id'] as String;
  }
}
