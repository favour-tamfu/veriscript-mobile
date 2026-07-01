import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../home/data/quota_repository.dart';
import '../data/ocr_service.dart';

final ocrNotifierProvider =
    NotifierProvider<OcrNotifier, OcrState>(OcrNotifier.new);

enum OcrSource { none, camera, gallery }

class OcrState {
  const OcrState({
    this.source = OcrSource.none,
    this.imageFile,
    this.ocrStatus = 'idle',
    this.recognisedText = '',
    this.errorMessage,
    this.isEditing = false,
  });

  final OcrSource source;
  final File? imageFile;
  final String ocrStatus;
  final String recognisedText;
  final String? errorMessage;
  final bool isEditing;

  OcrState copyWith({
    OcrSource? source,
    File? imageFile,
    String? ocrStatus,
    String? recognisedText,
    String? errorMessage,
    bool? isEditing,
    bool clearImage = false,
    bool clearError = false,
  }) {
    return OcrState(
      source: source ?? this.source,
      imageFile: clearImage ? null : imageFile ?? this.imageFile,
      ocrStatus: ocrStatus ?? this.ocrStatus,
      recognisedText: recognisedText ?? this.recognisedText,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class OcrNotifier extends Notifier<OcrState> {
  @override
  OcrState build() => const OcrState();

  Future<void> captureFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      state = state.copyWith(
        ocrStatus: 'failed',
        errorMessage: 'Camera permission required',
      );
      return;
    }

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (xFile == null) return;

    state = state.copyWith(
      source: OcrSource.camera,
      imageFile: File(xFile.path),
      ocrStatus: 'processing',
    );

    try {
      final text = await ref.read(ocrServiceProvider).recogniseFromCameraImage(xFile);
      state = state.copyWith(
        ocrStatus: 'done',
        recognisedText: text,
      );
      
      // Record in history and update quota
      await _recordOcrActivity(xFile.name, text.length);
    } catch (e) {
      state = state.copyWith(ocrStatus: 'failed', errorMessage: e.toString());
    }
  }

  Future<void> pickFromGallery() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (xFile == null) return;

    // Crop image (fall back to the original if cropping is unavailable).
    File file;
    String fileName = xFile.name;
    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Document',
            lockAspectRatio: false,
          ),
        ],
      );
      if (cropped != null) {
        file = File(cropped.path);
        fileName = cropped.path.split('/').last.split('\\').last;
      } else {
        file = File(xFile.path);
      }
    } catch (_) {
      file = File(xFile.path);
    }

    state = state.copyWith(
      source: OcrSource.gallery,
      imageFile: file,
      ocrStatus: 'processing',
    );

    try {
      final text = await ref.read(ocrServiceProvider).recogniseText(file);
      state = state.copyWith(ocrStatus: 'done', recognisedText: text);
      
      // Record in history and update quota
      await _recordOcrActivity(fileName, text.length);
    } catch (e) {
      state = state.copyWith(ocrStatus: 'failed', errorMessage: e.toString());
    }
  }

  Future<void> _recordOcrActivity(String fileName, int charCount) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Create a document entry so it shows in history
      await Supabase.instance.client.from('documents').insert({
        'user_id': user.id,
        'name': fileName,
        'type': 'image',
        'storage_path': '', // Local OCR doesn't upload by default
      });

      // 2. Increment OCR usage count
      await Supabase.instance.client.rpc('increment_ocr_used', params: {
        'p_user_id': user.id,
      });

      // 3. Refresh quota UI
      ref.invalidate(quotaProvider);
    } catch (e) {
      // Silently fail history recording for OCR to not block the user
      print('Failed to record OCR activity: $e');
    }
  }

  void toggleEdit() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  void updateText(String text) {
    state = state.copyWith(recognisedText: text);
  }

  Future<void> copyText() async {
    await Clipboard.setData(ClipboardData(text: state.recognisedText));
  }

  void reset() {
    state = const OcrState();
  }
}
