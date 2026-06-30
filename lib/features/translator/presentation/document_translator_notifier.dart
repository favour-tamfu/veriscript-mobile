import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../cloud/data/drive_repository.dart';
import '../../cloud/domain/drive_file.dart';
import '../../home/data/quota_repository.dart';
import '../../notifications/presentation/notifications_providers.dart';
import '../data/translation_repository.dart';

final documentTranslatorNotifierProvider =
    NotifierProvider<DocumentTranslatorNotifier, DocumentTranslatorState>(
  DocumentTranslatorNotifier.new,
);

class DocumentTranslatorState {
  const DocumentTranslatorState({
    this.selectedFile,
    this.fileName,
    this.fileSizeBytes,
    this.sourceLang = 'auto',
    this.targetLang = 'fr',
    this.status = 'idle',
    this.outputName,
    this.downloadUrl,
    this.detectedSourceLang,
    this.mimeType,
    this.errorMessage,
    this.driveSaveStatus,
  });

  final File? selectedFile;
  final String? fileName;
  final int? fileSizeBytes;
  final String sourceLang;
  final String targetLang;

  /// idle | uploading | translating | done | failed
  final String status;
  final String? outputName;
  final String? downloadUrl;
  final String? detectedSourceLang;
  final String? mimeType;
  final String? errorMessage;

  /// null | saving | saved | failed — feedback for the "Save to Drive" action.
  final String? driveSaveStatus;

  DocumentTranslatorState copyWith({
    File? selectedFile,
    String? fileName,
    int? fileSizeBytes,
    String? sourceLang,
    String? targetLang,
    String? status,
    String? outputName,
    String? downloadUrl,
    String? detectedSourceLang,
    String? mimeType,
    String? errorMessage,
    String? driveSaveStatus,
    bool clearFile = false,
    bool clearError = false,
    bool clearResult = false,
    bool clearDriveSave = false,
  }) {
    return DocumentTranslatorState(
      selectedFile: clearFile ? null : selectedFile ?? this.selectedFile,
      fileName: clearFile ? null : fileName ?? this.fileName,
      fileSizeBytes: clearFile ? null : fileSizeBytes ?? this.fileSizeBytes,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      status: status ?? this.status,
      outputName: clearResult ? null : outputName ?? this.outputName,
      downloadUrl: clearResult ? null : downloadUrl ?? this.downloadUrl,
      detectedSourceLang:
          clearResult ? null : detectedSourceLang ?? this.detectedSourceLang,
      mimeType: clearResult ? null : mimeType ?? this.mimeType,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      driveSaveStatus:
          clearDriveSave ? null : driveSaveStatus ?? this.driveSaveStatus,
    );
  }
}

class DocumentTranslatorNotifier extends Notifier<DocumentTranslatorState> {
  @override
  DocumentTranslatorState build() => const DocumentTranslatorState();

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: kTranslatableDocExtensions,
    );

    final path = result?.files.single.path;
    if (path == null) return;

    final file = File(path);
    final size = await file.length();
    if (size > 10 * 1024 * 1024) {
      state = state.copyWith(
        status: 'failed',
        errorMessage: 'File too large. Maximum size is 10MB.',
      );
      return;
    }

    state = DocumentTranslatorState(
      selectedFile: file,
      fileName: path.split('/').last.split('\\').last,
      fileSizeBytes: size,
      sourceLang: state.sourceLang,
      targetLang: state.targetLang,
    );
  }

  /// Stages an already-local file (e.g. from the library) for translation.
  Future<void> stageFile(File file, String name) async {
    final size = await file.length();
    state = DocumentTranslatorState(
      selectedFile: file,
      fileName: name,
      fileSizeBytes: size,
      sourceLang: state.sourceLang,
      targetLang: state.targetLang,
    );
  }

  void setSourceLang(String lang) =>
      state = state.copyWith(sourceLang: lang, clearError: true);

  void setTargetLang(String lang) =>
      state = state.copyWith(targetLang: lang, clearError: true);

  Future<void> translate() async {
    final file = state.selectedFile;
    final fileName = state.fileName;
    if (file == null || fileName == null) return;

    if (state.sourceLang == state.targetLang) {
      state = state.copyWith(
        status: 'failed',
        errorMessage: 'Source and target language are the same.',
      );
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      state = state.copyWith(
        status: 'failed',
        errorMessage: 'You must be signed in to translate.',
      );
      return;
    }

    final repo = ref.read(translationRepositoryProvider);

    state = state.copyWith(
      status: 'uploading',
      clearError: true,
      clearResult: true,
      clearDriveSave: true,
    );

    try {
      final storagePath = await repo.uploadDocument(file, userId);

      state = state.copyWith(status: 'translating');

      final result = await repo.translateDocument(
        storagePath: storagePath,
        fileName: fileName,
        sourceLang: state.sourceLang,
        targetLang: state.targetLang,
        userId: userId,
      );

      final url = await repo.getTranslatedDocUrl(result.outputPath);

      state = state.copyWith(
        status: 'done',
        outputName: result.outputName,
        downloadUrl: url,
        detectedSourceLang: result.detectedSourceLang,
        mimeType: result.mimeType,
      );

      // Refresh monthly usage UI
      ref.invalidate(quotaProvider);

      await pushAppNotification(
        ref,
        title: 'Document translated',
        body: '${result.outputName} is ready to download.',
        type: 'translation',
      );
    } catch (e) {
      state = state.copyWith(status: 'failed', errorMessage: e.toString());
    }
  }

  /// Imports a file chosen from Google Drive and stages it for translation.
  Future<void> importFromDrive(DriveFile driveFile) async {
    state = state.copyWith(
      status: 'importing',
      clearError: true,
      clearResult: true,
    );
    try {
      final file = await ref.read(driveRepositoryProvider).downloadFile(driveFile);
      final size = await file.length();
      if (size > 10 * 1024 * 1024) {
        state = state.copyWith(
          status: 'failed',
          errorMessage: 'File too large. Maximum size is 10MB.',
        );
        return;
      }
      state = DocumentTranslatorState(
        selectedFile: file,
        fileName: driveFile.name,
        fileSizeBytes: size,
        sourceLang: state.sourceLang,
        targetLang: state.targetLang,
      );
    } catch (e) {
      state = state.copyWith(status: 'failed', errorMessage: e.toString());
    }
  }

  /// Uploads the translated document back to the user's Google Drive.
  Future<void> saveToDrive() async {
    final url = state.downloadUrl;
    final name = state.outputName;
    if (url == null || name == null) return;

    state = state.copyWith(driveSaveStatus: 'saving', clearError: true);
    try {
      final repo = ref.read(driveRepositoryProvider);
      if (!repo.isSignedIn) {
        final account = await repo.signIn();
        if (account == null) {
          // User cancelled the Google sign-in sheet.
          state = state.copyWith(clearDriveSave: true);
          return;
        }
      }

      final dir = await getTemporaryDirectory();
      final localPath = p.join(dir.path, name);
      await Dio().download(url, localPath);

      await repo.uploadFile(
        File(localPath),
        name,
        state.mimeType ?? 'application/octet-stream',
      );
      state = state.copyWith(driveSaveStatus: 'saved');
    } catch (e) {
      state = state.copyWith(driveSaveStatus: 'failed', errorMessage: e.toString());
    }
  }

  /// Returns to the file-selected state so the user can retry or change options.
  void backToOptions() {
    if (state.selectedFile == null) {
      reset();
      return;
    }
    state = state.copyWith(status: 'idle', clearResult: true, clearError: true);
  }

  void reset() => state = const DocumentTranslatorState();
}
