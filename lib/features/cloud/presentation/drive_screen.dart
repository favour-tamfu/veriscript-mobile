import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/friendly_error.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_button.dart';
import '../../../core/widgets/vs_card.dart';
import '../domain/drive_file.dart';
import 'drive_notifier.dart';

class DriveScreen extends ConsumerStatefulWidget {
  const DriveScreen({super.key});

  @override
  ConsumerState<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends ConsumerState<DriveScreen> {
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

    return Scaffold(
      appBar: VsAppBar(
        title: state.userEmail != null ? 'Google Drive · ${state.userEmail}' : 'Google Drive',
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_special_outlined),
            tooltip: isFrench ? 'Ma bibliothèque' : 'My Library',
            onPressed: () => context.push(AppRoutes.library),
          ),
          if (state.isSignedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: isFrench ? 'Déconnecter Drive' : 'Disconnect Drive',
              onPressed: notifier.signOut,
            ),
        ],
      ),
      body: state.isSignedIn
          ? _buildFileList(context, state, notifier, isFrench)
          : _buildSignIn(context, state, notifier, isFrench),
    );
  }

  Widget _buildSignIn(
    BuildContext context,
    DriveState state,
    DriveNotifier notifier,
    bool isFrench,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 80, color: AppColors.vsGray),
            const SizedBox(height: 24),
            Text(
              isFrench ? 'Connecter Google Drive' : 'Connect Google Drive',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isFrench
                  ? 'Importez et exportez des documents directement depuis votre Drive'
                  : 'Import and export documents directly from your Drive',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.vsGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            VsButton.primary(
              label: isFrench ? 'Connecter avec Google' : 'Connect with Google',
              onPressed: notifier.signIn,
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                friendlyError(state.errorMessage, isFrench: isFrench),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.vsError),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(
    BuildContext context,
    DriveState state,
    DriveNotifier notifier,
    bool isFrench,
  ) {
    if (state.isLoading && state.files.isEmpty) {
      return _buildShimmer();
    }

    if (state.files.isEmpty && state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56, color: AppColors.vsError),
              const SizedBox(height: 16),
              Text(
                friendlyError(state.errorMessage, isFrench: isFrench),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.vsGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              VsButton.primary(
                label: isFrench ? 'Réessayer' : 'Try again',
                onPressed: () => notifier.loadFiles(),
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
              ? 'Aucun fichier supporté trouvé dans Drive'
              : 'No supported files found in Drive',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.vsGray),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.loadFiles(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.files.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.files.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.vsAccent),
              ),
            );
          }

          final file = state.files[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: VsCard(
              child: Row(
                children: [
                  Icon(_fileIcon(file.mimeType), color: AppColors.vsAccent, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _fileDetails(file, isFrench),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.vsGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download, color: AppColors.vsAccent),
                    tooltip: isFrench ? 'Importer' : 'Import',
                    onPressed: () => _importFile(context, file, notifier, isFrench),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Shimmer.fromColors(
          baseColor: AppColors.vsLightGray,
          highlightColor: AppColors.vsSurface,
          child: Container(height: 72, decoration: BoxDecoration(
            color: AppColors.vsSurface,
            borderRadius: BorderRadius.circular(12),
          )),
        ),
      ),
    );
  }

  Future<void> _importFile(
    BuildContext context,
    DriveFile file,
    DriveNotifier notifier,
    bool isFrench,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(isFrench
            ? 'Importation de ${file.name}...'
            : 'Importing ${file.name}...'),
        duration: const Duration(seconds: 1),
      ),
    );

    final saved = await notifier.importFile(file);
    if (!context.mounted) return;

    if (saved != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            isFrench ? 'Enregistré dans votre bibliothèque' : 'Saved to your Library',
          ),
          action: SnackBarAction(
            label: isFrench ? 'Voir' : 'View',
            onPressed: () => context.push(AppRoutes.library),
          ),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(isFrench ? 'Échec de l\'importation' : 'Import failed'),
          backgroundColor: AppColors.vsError,
        ),
      );
    }
  }
}

IconData _fileIcon(String mimeType) {
  if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
  if (mimeType.contains('word') || mimeType.contains('document')) return Icons.description;
  return Icons.article;
}

String _fileDetails(DriveFile file, bool isFrench) {
  final parts = <String>[];
  if (file.sizeBytes != null) {
    final kb = file.sizeBytes! / 1024;
    if (kb > 1024) {
      parts.add('${(kb / 1024).toStringAsFixed(1)} MB');
    } else {
      parts.add('${kb.toStringAsFixed(0)} KB');
    }
  }
  final date = file.modifiedTime;
  parts.add('${date.day}/${date.month}/${date.year}');
  return parts.join(' · ');
}
