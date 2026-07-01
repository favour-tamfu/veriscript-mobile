import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/drive_file.dart';
import 'drive_notifier.dart';

/// Shows a bottom sheet that lets the user pick a document from Google Drive.
/// Returns the chosen [DriveFile], or null if the sheet is dismissed.
Future<DriveFile?> showDriveFilePicker(BuildContext context) {
  return showModalBottomSheet<DriveFile>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.vsSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _DriveFilePickerSheet(),
  );
}

class _DriveFilePickerSheet extends ConsumerStatefulWidget {
  const _DriveFilePickerSheet();

  @override
  ConsumerState<_DriveFilePickerSheet> createState() =>
      _DriveFilePickerSheetState();
}

class _DriveFilePickerSheetState extends ConsumerState<_DriveFilePickerSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(driveNotifierProvider);
      if (state.isSignedIn && state.files.isEmpty) {
        ref.read(driveNotifierProvider.notifier).loadFiles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final state = ref.watch(driveNotifierProvider);
    final notifier = ref.read(driveNotifierProvider.notifier);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.vsLightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.cloud, color: AppColors.vsAccent),
                  const SizedBox(width: 8),
                  Text(
                    isFrench ? 'Choisir dans Drive' : 'Choose from Drive',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildContent(context, state, notifier, isFrench, controller),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    DriveState state,
    DriveNotifier notifier,
    bool isFrench,
    ScrollController controller,
  ) {
    if (!state.isSignedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 56, color: AppColors.vsGray),
              const SizedBox(height: 16),
              Text(
                isFrench
                    ? 'Connectez Google Drive pour choisir un document'
                    : 'Connect Google Drive to choose a document',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.vsGray),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: state.isLoading ? null : notifier.signIn,
                icon: const Icon(Icons.login),
                label: Text(
                  isFrench ? 'Connecter avec Google' : 'Connect with Google',
                ),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.vsError),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (state.isLoading && state.files.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.vsAccent),
      );
    }

    if (state.errorMessage != null && state.files.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.vsError),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => notifier.loadFiles(),
                child: Text(isFrench ? 'Réessayer' : 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.files.isEmpty) {
      return Center(
        child: Text(
          isFrench
              ? 'Aucun document compatible dans Drive'
              : 'No compatible documents in Drive',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.vsGray),
        ),
      );
    }

    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.files.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final file = state.files[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(_fileIcon(file.mimeType), color: AppColors.vsAccent),
          title: Text(
            file.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(_fileSubtitle(file)),
          onTap: () => Navigator.pop(context, file),
        );
      },
    );
  }
}

IconData _fileIcon(String mimeType) {
  if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
  if (mimeType.contains('word') || mimeType.contains('document')) {
    return Icons.description;
  }
  return Icons.article;
}

String _fileSubtitle(DriveFile file) {
  final parts = <String>[];
  if (file.sizeBytes != null) {
    final kb = file.sizeBytes! / 1024;
    parts.add(kb > 1024
        ? '${(kb / 1024).toStringAsFixed(1)} MB'
        : '${kb.toStringAsFixed(0)} KB');
  }
  final d = file.modifiedTime;
  parts.add('${d.day}/${d.month}/${d.year}');
  return parts.join(' · ');
}
