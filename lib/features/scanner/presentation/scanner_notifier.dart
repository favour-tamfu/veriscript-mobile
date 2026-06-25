import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../notifications/presentation/notifications_providers.dart';
import '../data/scan_repository.dart';
import '../domain/scan_job.dart';

final scannerNotifierProvider =
    NotifierProvider<ScannerNotifier, ScannerState>(ScannerNotifier.new);

class ScannerState {
  const ScannerState({
    this.selectedFile,
    this.fileName,
    this.fileSizeBytes,
    this.scanStatus = 'idle',
    this.currentReportId,
    this.progressEstimate,
    this.errorMessage,
    this.completedJob,
    this.detectAi = true,
  });

  final File? selectedFile;
  final String? fileName;
  final int? fileSizeBytes;
  final String scanStatus;
  final String? currentReportId;
  final double? progressEstimate;
  final String? errorMessage;
  final ScanJob? completedJob;
  final bool detectAi;

  ScannerState copyWith({
    File? selectedFile,
    String? fileName,
    int? fileSizeBytes,
    String? scanStatus,
    String? currentReportId,
    double? progressEstimate,
    String? errorMessage,
    ScanJob? completedJob,
    bool? detectAi,
    bool clearFile = false,
    bool clearError = false,
    bool clearProgress = false,
  }) {
    return ScannerState(
      selectedFile: clearFile ? null : selectedFile ?? this.selectedFile,
      fileName: clearFile ? null : fileName ?? this.fileName,
      fileSizeBytes: clearFile ? null : fileSizeBytes ?? this.fileSizeBytes,
      scanStatus: scanStatus ?? this.scanStatus,
      currentReportId: currentReportId ?? this.currentReportId,
      progressEstimate: clearProgress ? null : progressEstimate ?? this.progressEstimate,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      completedJob: completedJob ?? this.completedJob,
      detectAi: detectAi ?? this.detectAi,
    );
  }
}

class ScannerNotifier extends Notifier<ScannerState> {
  StreamSubscription<ScanJob>? _jobSubscription;
  Timer? _progressTimer;

  @override
  ScannerState build() {
    ref.onDispose(() {
      _jobSubscription?.cancel();
      _progressTimer?.cancel();
    });
    return const ScannerState();
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'docx', 'txt'],
    );

    final path = result?.files.single.path;
    if (path == null) return;

    final file = File(path);
    final size = await file.length();
    if (size > 10 * 1024 * 1024) {
      state = state.copyWith(
        scanStatus: 'failed',
        errorMessage: 'File too large. Maximum size is 10MB.',
      );
      return;
    }

    state = ScannerState(
      selectedFile: file,
      fileName: path.split('/').last.split('\\').last,
      fileSizeBytes: size,
      scanStatus: 'idle',
      detectAi: state.detectAi,
    );
  }

  void setDetectAi(bool value) {
    state = state.copyWith(detectAi: value);
  }

  Future<void> startScan() async {
    final file = state.selectedFile;
    final fileName = state.fileName;
    if (file == null || fileName == null) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      state = state.copyWith(
        scanStatus: 'failed',
        errorMessage: 'You must be signed in to scan.',
      );
      return;
    }

    // Show the loader immediately so the tap has instant feedback, even while
    // the quota check and upload are still in flight.
    state = state.copyWith(
      scanStatus: 'uploading',
      clearError: true,
      progressEstimate: 0.02,
    );

    final repository = ref.read(scanRepositoryProvider);

    final canScan = await repository.canScan(userId);
    if (!canScan) {
      state = state.copyWith(scanStatus: 'quota_exceeded');
      return;
    }

    try {
      final ext = fileName.split('.').last.toLowerCase();
      final storagePath = await repository.uploadDocument(file, userId);

      final job = await repository.createScanJob(storagePath, fileName, ext, userId);

      state = state.copyWith(
        currentReportId: job.reportId,
        scanStatus: 'scanning',
        progressEstimate: 0.05,
      );

      _startProgressSimulation();

      await repository.startScan(
        job.reportId,
        storagePath,
        job.documentId,
        userId,
        detectAi: state.detectAi,
      );

      await _jobSubscription?.cancel();
      _jobSubscription = repository.watchScanJob(job.reportId).listen(
        (scanJob) {
          if (scanJob.status == 'done') {
            _progressTimer?.cancel();
            state = state.copyWith(
              scanStatus: 'done',
              completedJob: scanJob,
              progressEstimate: 1.0,
            );
            final sim = scanJob.similarityPct?.round();
            pushAppNotification(
              ref,
              title: 'Scan complete',
              body: sim != null
                  ? 'Originality report ready · $sim% similarity.'
                  : 'Your originality report is ready.',
              type: 'scan',
            );
          } else if (scanJob.status == 'failed') {
            _progressTimer?.cancel();
            state = state.copyWith(
              scanStatus: 'failed',
              errorMessage: scanJob.errorMessage ?? 'scan_error',
              clearProgress: true,
            );
          }
        },
        onError: (_) {
          _progressTimer?.cancel();
          state = state.copyWith(
            scanStatus: 'failed',
            errorMessage: 'Could not track scan status.',
          );
        },
      );

      await repository.incrementScanCount(userId);
    } catch (error) {
      _progressTimer?.cancel();
      state = state.copyWith(
        scanStatus: 'failed',
        errorMessage: error.toString(),
      );
    }
  }

  void cancel() {
    _jobSubscription?.cancel();
    _progressTimer?.cancel();
    _jobSubscription = null;
    state = const ScannerState();
  }

  void reset() {
    _jobSubscription?.cancel();
    _progressTimer?.cancel();
    _jobSubscription = null;
    state = const ScannerState();
  }

  void _startProgressSimulation() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final current = state.progressEstimate ?? 0.0;
      if (current < 0.9) {
        state = state.copyWith(progressEstimate: (current + 0.08).clamp(0.0, 0.9));
      }
    });
  }
}
