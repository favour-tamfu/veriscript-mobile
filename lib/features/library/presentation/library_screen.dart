import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_empty_state.dart';
import '../../translator/data/translation_repository.dart';
import '../../translator/presentation/document_translator_notifier.dart';
import '../data/library_repository.dart';
import '../domain/library_file.dart';
import 'library_providers.dart';

/// The in-app "bucket": files saved for later (e.g. imported from Drive).
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final async = ref.watch(libraryFilesProvider);

    return Scaffold(
      appBar: VsAppBar(title: isFrench ? 'Ma bibliothèque' : 'My Library'),
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.vsAccent),
        ),
        error: (_, __) => Center(
          child:
              Text(isFrench ? 'Une erreur est survenue' : 'Something went wrong'),
        ),
        data: (files) {
          if (files.isEmpty) {
            return VsEmptyState(
              lottieAsset: 'assets/animations/empty.json',
              title: isFrench ? 'Bibliothèque vide' : 'Library is empty',
              subtitle: isFrench
                  ? 'Importez des fichiers depuis Google Drive pour les réutiliser ici.'
                  : 'Import files from Google Drive to reuse them here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: files.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) =>
                _tile(context, ref, files[index], isFrench),
          );
        },
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    WidgetRef ref,
    LibraryFile file,
    bool isFrench,
  ) {
    final canTranslate =
        kTranslatableDocExtensions.contains(file.extension);

    return ListTile(
      leading: Icon(_iconFor(file.extension), color: AppColors.vsAccent),
      title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(_subtitle(file, isFrench)),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          switch (value) {
            case 'open':
              await OpenFile.open(file.localPath);
            case 'translate':
              await ref
                  .read(documentTranslatorNotifierProvider.notifier)
                  .stageFile(File(file.localPath), file.name);
              if (context.mounted) context.push(AppRoutes.translatorDocument);
            case 'delete':
              final userId = Supabase.instance.client.auth.currentUser?.id;
              if (userId == null) return;
              await ref
                  .read(libraryRepositoryProvider)
                  .delete(userId, file);
              ref.invalidate(libraryFilesProvider);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'open',
            child: Row(
              children: [
                const Icon(Icons.open_in_new, size: 18),
                const SizedBox(width: 8),
                Text(isFrench ? 'Ouvrir' : 'Open'),
              ],
            ),
          ),
          if (canTranslate)
            PopupMenuItem(
              value: 'translate',
              child: Row(
                children: [
                  const Icon(Icons.translate, size: 18),
                  const SizedBox(width: 8),
                  Text(isFrench ? 'Traduire' : 'Translate'),
                ],
              ),
            ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete_outline,
                    size: 18, color: AppColors.vsError),
                const SizedBox(width: 8),
                Text(
                  isFrench ? 'Supprimer' : 'Delete',
                  style: const TextStyle(color: AppColors.vsError),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () => OpenFile.open(file.localPath),
    );
  }
}

IconData _iconFor(String ext) {
  switch (ext) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'docx':
    case 'doc':
      return Icons.description;
    case 'pptx':
      return Icons.slideshow;
    case 'xlsx':
      return Icons.table_chart;
    case 'txt':
      return Icons.article;
    default:
      return Icons.insert_drive_file;
  }
}

String _subtitle(LibraryFile file, bool isFrench) {
  final parts = <String>[];
  final kb = file.sizeBytes / 1024;
  parts.add(kb > 1024
      ? '${(kb / 1024).toStringAsFixed(1)} MB'
      : '${kb.toStringAsFixed(0)} KB');
  if (file.origin == 'drive') parts.add('Google Drive');
  final d = file.savedAt;
  parts.add('${d.day}/${d.month}/${d.year}');
  return parts.join(' · ');
}
