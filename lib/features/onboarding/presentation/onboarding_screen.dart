import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_shell.dart';
import '../../auth/presentation/auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const routeName = 'onboarding';
  static const routePath = '/onboarding';

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    final theme = Theme.of(context);

    return AppShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.tealMint.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_mosaic_rounded,
                    color: AppColors.tealMint,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.onboardingTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.onboardingBody,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.slate,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _FeatureChip(label: 'Plagiarism'),
                    _FeatureChip(label: 'OCR'),
                    _FeatureChip(label: 'Translate'),
                    _FeatureChip(label: 'Offline'),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
      footer: FilledButton(
        onPressed: () => context.go(AuthScreen.routePath),
        child: Text(l10n.getStarted),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5F3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
