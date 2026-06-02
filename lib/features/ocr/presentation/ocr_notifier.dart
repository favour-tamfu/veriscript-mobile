import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
        ocrStatus: text.isEmpty ? 'done' : 'done',
        recognisedText: text,
      );
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
      file = File(cropped?.path ?? xFile.path);
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
    } catch (e) {
      state = state.copyWith(ocrStatus: 'failed', errorMessage: e.toString());
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
