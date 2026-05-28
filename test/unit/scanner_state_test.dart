import 'package:flutter_test/flutter_test.dart';
import 'package:veriscipt_mobile/features/scanner/presentation/scanner_notifier.dart';

void main() {
  group('ScannerState — initial values', () {
    test('default status is idle', () {
      expect(const ScannerState().scanStatus, 'idle');
    });

    test('all optional fields are null by default', () {
      const state = ScannerState();
      expect(state.selectedFile, isNull);
      expect(state.fileName, isNull);
      expect(state.fileSizeBytes, isNull);
      expect(state.currentReportId, isNull);
      expect(state.progressEstimate, isNull);
      expect(state.errorMessage, isNull);
      expect(state.completedJob, isNull);
    });
  });

  group('ScannerState.copyWith', () {
    test('updates scanStatus', () {
      const state = ScannerState();
      expect(state.copyWith(scanStatus: 'uploading').scanStatus, 'uploading');
    });

    test('preserves unchanged fields', () {
      const state = ScannerState(
        fileName: 'essay.pdf',
        fileSizeBytes: 204800,
        scanStatus: 'scanning',
        progressEstimate: 0.35,
      );
      final updated = state.copyWith(scanStatus: 'done', progressEstimate: 1.0);
      expect(updated.fileName, 'essay.pdf');
      expect(updated.fileSizeBytes, 204800);
      expect(updated.progressEstimate, 1.0);
      expect(updated.scanStatus, 'done');
    });

    test('clearFile nulls file-related fields', () {
      const state = ScannerState(fileName: 'doc.pdf', fileSizeBytes: 1024);
      final cleared = state.copyWith(clearFile: true);
      expect(cleared.fileName, isNull);
      expect(cleared.fileSizeBytes, isNull);
      expect(cleared.selectedFile, isNull);
    });

    test('clearError nulls errorMessage', () {
      const state = ScannerState(errorMessage: 'Upload failed');
      expect(state.copyWith(clearError: true).errorMessage, isNull);
    });

    test('clearProgress nulls progressEstimate', () {
      const state = ScannerState(progressEstimate: 0.7);
      expect(state.copyWith(clearProgress: true).progressEstimate, isNull);
    });

    test('can transition through all status values', () {
      const statuses = ['idle', 'uploading', 'scanning', 'done', 'failed', 'quota_exceeded'];
      var state = const ScannerState();
      for (final status in statuses) {
        state = state.copyWith(scanStatus: status);
        expect(state.scanStatus, status);
      }
    });
  });
}
