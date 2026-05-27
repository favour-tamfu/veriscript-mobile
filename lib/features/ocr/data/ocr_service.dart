import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

final ocrServiceProvider = Provider<OcrService>((ref) {
  final service = OcrService();
  ref.onDispose(service.dispose);
  return service;
});

class OcrService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> recogniseText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognised = await _textRecognizer.processImage(inputImage);
    return recognised.text;
  }

  Future<String> recogniseFromCameraImage(XFile xFile) async {
    final inputImage = InputImage.fromFilePath(xFile.path);
    final recognised = await _textRecognizer.processImage(inputImage);
    return recognised.text;
  }

  void dispose() => _textRecognizer.close();
}
