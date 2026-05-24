import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/local_db/app_database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_empty_state.dart';

final historyDocumentsProvider =
    StreamProvider<List<DocumentsTableData>>((ref) {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) {
    return Stream.value(const <DocumentsTableData>[]);
  }

  return ref.watch(documentsDaoProvider).watchAllDocuments(userId);
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final documentsAsync = ref.watch(historyDocumentsProvider);

    return Scaffold(
      appBar: VsAppBar(title: isFrench ? 'Historique' : 'History'),
      body: documentsAsync.when(
        data: (documents) {
          if (documents.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: VsEmptyState(
                lottieAsset: 'assets/animations/empty.json',
                title: isFrench ? 'Aucun document' : 'No documents yet',
                subtitle: isFrench
                    ? 'Importez votre premier document!'
                    : 'Upload your first document!',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return Dismissible(
                key: ValueKey(document.id),
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.vsError,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref.read(documentsDaoProvider).deleteDocument(document.id);
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      _historyIcon(document.type),
                      color: AppColors.vsAccent,
                    ),
                    title: Text(document.name),
                    subtitle: Text(
                      DateFormat.yMMMd().format(document.createdAt),
                    ),
                    trailing: Chip(
                      label: Text(document.type.toUpperCase()),
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

IconData _historyIcon(String type) {
  switch (type.toLowerCase()) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'docx':
      return Icons.description;
    default:
      return Icons.article;
  }
}
