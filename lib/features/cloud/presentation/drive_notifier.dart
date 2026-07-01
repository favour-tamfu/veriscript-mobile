import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../library/data/library_repository.dart';
import '../../library/domain/library_file.dart';
import '../../library/presentation/library_providers.dart';
import '../data/drive_repository.dart';
import '../domain/drive_file.dart';

final driveNotifierProvider =
    NotifierProvider<DriveNotifier, DriveState>(DriveNotifier.new);

class DriveState {
  const DriveState({
    this.isSignedIn = false,
    this.userEmail,
    this.files = const [],
    this.isLoading = false,
    this.nextPageToken,
    this.errorMessage,
  });

  final bool isSignedIn;
  final String? userEmail;
  final List<DriveFile> files;
  final bool isLoading;
  final String? nextPageToken;
  final String? errorMessage;

  DriveState copyWith({
    bool? isSignedIn,
    String? userEmail,
    List<DriveFile>? files,
    bool? isLoading,
    String? nextPageToken,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DriveState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      userEmail: userEmail ?? this.userEmail,
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      nextPageToken: nextPageToken ?? this.nextPageToken,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class DriveNotifier extends Notifier<DriveState> {
  @override
  DriveState build() {
    final repo = ref.read(driveRepositoryProvider);
    if (repo.isSignedIn) {
      return DriveState(isSignedIn: true, userEmail: repo.currentUser?.email);
    }
    return const DriveState();
  }

  Future<void> signIn() async {
    final repo = ref.read(driveRepositoryProvider);
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final account = await repo.signIn();
      if (account != null) {
        state = state.copyWith(isSignedIn: true, userEmail: account.email, isLoading: false);
        await loadFiles();
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await ref.read(driveRepositoryProvider).signOut();
    state = const DriveState();
  }

  Future<void> loadFiles({String? folderId}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final files = await ref.read(driveRepositoryProvider).listFiles(folderId: folderId);
      state = state.copyWith(files: files, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadMore() async {
    final token = state.nextPageToken;
    if (token == null) return;
    state = state.copyWith(isLoading: true);
    try {
      final more = await ref.read(driveRepositoryProvider).listFiles(pageToken: token);
      state = state.copyWith(files: [...state.files, ...more], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Downloads a Drive file and saves it into the local library bucket so it can
  /// be reused later (e.g. translated). Returns the saved [LibraryFile], or null
  /// on failure.
  Future<LibraryFile?> importFile(DriveFile file) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final local = await ref.read(driveRepositoryProvider).downloadFile(file);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'Not signed in.');
        return null;
      }
      final saved = await ref.read(libraryRepositoryProvider).save(
            userId: userId,
            source: local,
            name: file.name,
            mimeType: file.mimeType,
            origin: 'drive',
          );
      ref.invalidate(libraryFilesProvider);
      state = state.copyWith(isLoading: false);
      return saved;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  Future<void> exportFile(File localFile, String name, String mimeType) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref.read(driveRepositoryProvider).uploadFile(localFile, name, mimeType);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
