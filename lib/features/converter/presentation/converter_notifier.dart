import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../data/conversion_repository.dart';

final converterNotifierProvider =
    NotifierProvider<ConverterNotifier, ConverterState>(
  ConverterNotifier.new,
);

class ConverterState {
  const ConverterState({
    this.selectedFile,
    this.fromFormat,
    this.toFormat = '',
    this.currentJobId,
    this.jobStatus = 'idle',
    this.downloadUrl,
    this.errorMessage,
  });

  final File? selectedFile;
  final String? fromFormat;
  final String toFormat;
  final String? currentJobId;
  final String jobStatus;
  final String? downloadUrl;
  final String? errorMessage;

  ConverterState copyWith({
    File? selectedFile,
    String? fromFormat,
    String? toFormat,
    String? currentJobId,
    String? jobStatus,
    String? downloadUrl,
    String? errorMessage,
    bool clearSelectedFile = false,
    bool clearDownloadUrl = false,
    bool clearError = false,
  }) {
    return ConverterState(
      selectedFile: clearSelectedFile ? null : selectedFile ?? this.selectedFile,
      fromFormat: fromFormat ?? this.fromFormat,
      toFormat: toFormat ?? this.toFormat,
      currentJobId: currentJobId ?? this.currentJobId,
      jobStatus: jobStatus ?? this.jobStatus,
      downloadUrl: clearDownloadUrl ? null : downloadUrl ?? this.downloadUrl,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ConverterNotifier extends Notifier<ConverterState> {
  StreamSubscription<String>? _jobSubscription;

  @override
  ConverterState build() {
    ref.onDispose(() {
      _jobSubscription?.cancel();
    });
    return const ConverterState();
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'docx', 'txt'],
    );

    final path = result?.files.single.path;
    if (path == null) {
      return null;
    }

    final file = File(path);
    final format = p.extension(path).replaceFirst('.', '').toLowerCase();
    state = ConverterState(
      selectedFile: file,
      fromFormat: format,
      toFormat: '',
      jobStatus: 'idle',
    );
    return file;
  }

  void setTargetFormat(String format) {
    state = state.copyWith(toFormat: format, clearError: true);
  }

  Future<void> startConversion() async {
    final file = state.selectedFile;
    final fromFormat = state.fromFormat;
    final toFormat = state.toFormat;

    if (file == null || fromFormat == null || toFormat.isEmpty) {
      state = state.copyWith(
        jobStatus: 'failed',
        errorMessage: 'Missing file or target format.',
      );
      return;
    }

    state = state.copyWith(
      jobStatus: 'uploading',
      clearError: true,
      clearDownloadUrl: true,
    );

    try {
      final repository = ref.read(conversionRepositoryProvider);
      final storagePath = await repository.uploadFile(file);
      final jobId = await repository.insertJob(fromFormat, toFormat, storagePath);

      state = state.copyWith(
        currentJobId: jobId,
        jobStatus: 'processing',
      );

      await repository.callConvertEdgeFunction(
        jobId,
        storagePath,
        fromFormat,
        toFormat,
      );

      await _jobSubscription?.cancel();
      _jobSubscription = repository.watchJobStatus(jobId).listen(
        (status) async {
          if (status == 'done') {
            final outputPath = 'placeholder/converted_$jobId.$toFormat';
            final downloadUrl =
                await repository.getSignedDownloadUrl(outputPath);
            state = state.copyWith(
              jobStatus: 'done',
              downloadUrl: downloadUrl,
            );
            return;
          }

          if (status == 'failed') {
            state = state.copyWith(
              jobStatus: 'failed',
              errorMessage: 'Conversion failed. Please try again.',
            );
            return;
          }

          state = state.copyWith(jobStatus: status);
        },
        onError: (_) {
          state = state.copyWith(
            jobStatus: 'failed',
            errorMessage: 'Could not track conversion status.',
          );
        },
      );
    } catch (error) {
      state = state.copyWith(
        jobStatus: 'failed',
        errorMessage: error.toString(),
      );
    }
  }

  void reset() {
    _jobSubscription?.cancel();
    _jobSubscription = null;
    state = const ConverterState();
  }
}
