import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../l10n/app_localizations.dart';
import '../application/document_providers.dart';

class DocumentLibraryScreen extends ConsumerWidget {
  const DocumentLibraryScreen({super.key});

  static const routeName = 'documents';
  static const routePath = '/documents';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final documentsAsync = ref.watch(allDocumentsProvider);

    return AppShell(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.libraryTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.libraryBody,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
      child: documentsAsync.when(
        data: (documents) {
          if (documents.isEmpty) {
            return Center(
              child: Text(
                l10n.libraryEmpty,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            itemCount: documents.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final document = documents[index];
              return _DocumentTile(document: document);
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document});

  final Document document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${document.kind} • ${document.status}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.slate,
              ),
            ),
            if (document.details != null) ...[
              const SizedBox(height: 8),
              Text(document.details!),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                if (document.sourcePath != null)
                  OutlinedButton.icon(
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(files: [XFile(document.sourcePath!)]),
                    ),
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Share source'),
                  ),
                if (document.remoteUrl != null)
                  OutlinedButton.icon(
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(text: document.remoteUrl!),
                    ),
                    icon: const Icon(Icons.link_rounded),
                    label: const Text('Share result link'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
