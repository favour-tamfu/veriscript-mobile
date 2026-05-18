import 'dart:math';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_providers.dart';

final converterControllerProvider =
    AsyncNotifierProvider<ConverterController, void>(ConverterController.new);

class ConverterController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> pickAndConvert(String targetFormat) async {
    final selection = await FilePicker.platform.pickFiles(withData: false);
    if (selection == null || selection.files.isEmpty) {
      return 'No file selected.';
    }

    final file = selection.files.single;
    if (file.path == null) {
      return 'The selected file could not be accessed.';
    }

    state = const AsyncLoading();

    final database = ref.read(appDatabaseProvider);
    final config = ref.read(appConfigProvider);
    final now = DateTime.now();
    final documentId = _createId();

    await database.saveDocument(
      DocumentsCompanion.insert(
        id: documentId,
        name: file.name,
        sourcePath: drift.Value(file.path),
        targetFormat: drift.Value(targetFormat),
        kind: 'conversion',
        status: 'pending',
        details: const drift.Value('Waiting for converter response'),
        createdAt: now,
        updatedAt: now,
      ),
    );

    if (!config.hasConverterEndpoint) {
      await database.saveDocument(
        DocumentsCompanion(
          id: drift.Value(documentId),
          name: drift.Value(file.name),
          sourcePath: drift.Value(file.path),
          targetFormat: drift.Value(targetFormat),
          kind: const drift.Value('conversion'),
          status: const drift.Value('needs_setup'),
          details: const drift.Value(
            'Set CONVERTER_ENDPOINT to enable server-side conversion.',
          ),
          createdAt: drift.Value(now),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );
      state = const AsyncData(null);
      return null;
    }

    try {
      final response = await Dio().post<Map<String, dynamic>>(
        config.converterEndpoint,
        data: FormData.fromMap({
          'targetFormat': targetFormat,
          'file': await MultipartFile.fromFile(
            file.path!,
            filename: file.name,
          ),
        }),
      );

      final data = response.data ?? const <String, dynamic>{};
      final downloadUrl = data['downloadUrl'] as String?;
      final message =
          data['message'] as String? ?? 'Conversion request completed.';

      await database.saveDocument(
        DocumentsCompanion(
          id: drift.Value(documentId),
          name: drift.Value(file.name),
          sourcePath: drift.Value(file.path),
          targetFormat: drift.Value(targetFormat),
          kind: const drift.Value('conversion'),
          status: const drift.Value('completed'),
          details: drift.Value(message),
          remoteUrl: drift.Value(downloadUrl),
          createdAt: drift.Value(now),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      state = const AsyncData(null);
      return null;
    } catch (error, stackTrace) {
      await database.saveDocument(
        DocumentsCompanion(
          id: drift.Value(documentId),
          name: drift.Value(file.name),
          sourcePath: drift.Value(file.path),
          targetFormat: drift.Value(targetFormat),
          kind: const drift.Value('conversion'),
          status: const drift.Value('failed'),
          details: drift.Value(error.toString()),
          createdAt: drift.Value(now),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      state = AsyncError(error, stackTrace);
      return 'Conversion failed. ${error.runtimeType}';
    }
  }

  String _createId() {
    final random = Random();
    return '${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(99999)}';
  }
}
