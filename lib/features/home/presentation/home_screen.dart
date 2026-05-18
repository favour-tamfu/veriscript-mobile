import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/application/auth_controller.dart';
import '../../converter/presentation/converter_screen.dart';
import '../../documents/application/document_providers.dart';
import '../../documents/presentation/document_library_screen.dart';
import '../../subscription/presentation/paywall_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';
  static const routePath = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authUser = ref.watch(authSessionProvider).value;
    final recentDocuments = ref.watch(recentDocumentsProvider);
    final bootstrapNotes = ref.watch(bootstrapNotesProvider);

    return AppShell(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeGreeting,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            authUser == null
                ? l10n.homeSubtitle
                : l10n.homeSubtitleWithEmail(authUser.email),
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.push(ConverterScreen.routePath),
                icon: const Icon(Icons.sync_alt_rounded),
                label: Text(l10n.openConverter),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.push(DocumentLibraryScreen.routePath),
                icon: const Icon(Icons.folder_open_rounded),
                label: Text(l10n.openLibrary),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.push(PaywallScreen.routePath),
                icon: const Icon(Icons.workspace_premium_rounded),
                label: Text(l10n.openPlans),
              ),
            ],
          ),
        ],
      ),
      child: ListView(
        children: [
          const _QuotaCard(),
          const SizedBox(height: 18),
          if (bootstrapNotes.isNotEmpty) ...[
            _SetupNotes(notes: bootstrapNotes),
            const SizedBox(height: 18),
          ],
          _ToolCard(
            icon: Icons.find_in_page_outlined,
            title: l10n.toolPlagiarismTitle,
            subtitle: l10n.toolPlagiarismBody,
          ),
          const SizedBox(height: 12),
          _ToolCard(
            icon: Icons.sync_alt_rounded,
            title: l10n.toolConversionTitle,
            subtitle: l10n.toolConversionBody,
          ),
          const SizedBox(height: 12),
          _ToolCard(
            icon: Icons.translate_rounded,
            title: l10n.toolTranslationTitle,
            subtitle: l10n.toolTranslationBody,
          ),
          const SizedBox(height: 12),
          _ToolCard(
            icon: Icons.offline_pin_rounded,
            title: l10n.toolOfflineTitle,
            subtitle: l10n.toolOfflineBody,
          ),
          const SizedBox(height: 18),
          Text(
            l10n.recentDocuments,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          recentDocuments.when(
            data: (items) {
              if (items.isEmpty) {
                return Text(
                  l10n.libraryEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.slate,
                  ),
                );
              }

              return Column(
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RecentDocumentCard(document: item),
                      ),
                    )
                    .cast<Widget>()
                    .toList(),
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authActionControllerProvider.notifier).signOut();
            },
            icon: const Icon(Icons.logout_rounded),
            label: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}

class _SetupNotes extends StatelessWidget {
  const _SetupNotes({required this.notes});

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: notes.map((note) => Text('- $note')).toList(),
      ),
    );
  }
}

class _QuotaCard extends StatelessWidget {
  const _QuotaCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free plan',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '3 scans left this month',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.6,
              minHeight: 10,
              backgroundColor: Color(0x3355FFFF),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.amberGold),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentDocumentCard extends StatelessWidget {
  const _RecentDocumentCard({required this.document});

  final Document document;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              '${document.kind} • ${document.status}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
            ),
            if (document.details != null) ...[
              const SizedBox(height: 8),
              Text(document.details!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.tealMint.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.tealMint),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
