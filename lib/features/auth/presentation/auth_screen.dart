import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_shell.dart';
import '../../home/presentation/home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const routeName = 'auth';
  static const routePath = '/auth';

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    final theme = Theme.of(context);

    return AppShell(
      child: ListView(
        children: [
          Text(
            l10n.authTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.authBody,
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: 24),
          const _AuthField(
            label: 'Email address',
            icon: Icons.alternate_email_rounded,
          ),
          const SizedBox(height: 16),
          const _AuthField(
            label: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(HomeScreen.routePath),
            child: Text(l10n.signIn),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go(HomeScreen.routePath),
            child: Text(l10n.createAccount),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.authHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  final String label;
  final IconData icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
