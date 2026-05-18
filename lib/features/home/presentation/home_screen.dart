import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';
  static const routePath = '/home';

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    final theme = Theme.of(context);

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
            l10n.homeSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
      child: ListView(
        children: const [
          _QuotaCard(),
          SizedBox(height: 18),
          _ToolCard(
            icon: Icons.find_in_page_outlined,
            title: 'Plagiarism check',
            subtitle: 'Compare drafts before submission.',
          ),
          SizedBox(height: 12),
          _ToolCard(
            icon: Icons.sync_alt_rounded,
            title: 'File conversion',
            subtitle: 'Convert PDF, DOCX, and TXT with low-data feedback.',
          ),
          SizedBox(height: 12),
          _ToolCard(
            icon: Icons.translate_rounded,
            title: 'Translation',
            subtitle:
                'English and French workflows with 100+ target languages.',
          ),
          SizedBox(height: 12),
          _ToolCard(
            icon: Icons.offline_pin_rounded,
            title: 'Offline vault',
            subtitle: 'Keep recent documents available without a connection.',
          ),
        ],
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
                color: AppColors.tealMint.withOpacity(0.12),
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
