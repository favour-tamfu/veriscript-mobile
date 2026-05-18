import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../l10n/app_localizations.dart';
import '../application/auth_controller.dart';
import '../../home/presentation/home_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  static const routeName = 'auth';
  static const routePath = '/auth';

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n;
    final theme = Theme.of(context);
    final authAction = ref.watch(authActionControllerProvider);

    return AppShell(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
          Text(
            _isSignUp ? l10n.authCreateTitle : l10n.authTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _isSignUp ? l10n.authCreateBody : l10n.authBody,
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: 24),
          _AuthField(
            controller: _emailController,
            label: l10n.emailAddress,
            icon: Icons.alternate_email_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty || !value.contains('@')) {
                return l10n.authEmailError;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _AuthField(
            controller: _passwordController,
            label: l10n.password,
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.authPasswordError;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: authAction.isLoading ? null : _submitPrimaryAction,
            child: Text(_isSignUp ? l10n.createAccount : l10n.signIn),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: authAction.isLoading
                ? null
                : () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                    });
                  },
            child: Text(
              _isSignUp ? l10n.switchToSignIn : l10n.createAccount,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: authAction.isLoading ? null : _resetPassword,
            child: Text(l10n.resetPassword),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.authHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.slate),
          ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitPrimaryAction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(authActionControllerProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final message = _isSignUp
        ? await controller.signUp(email: email, password: password)
        : await controller.signIn(email: email, password: password);

    if (!mounted) {
      return;
    }

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    context.go(HomeScreen.routePath);
  }

  Future<void> _resetPassword() async {
    final l10n = _l10n;

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.authResetNeedsEmail)));
      return;
    }

    final message = await ref
        .read(authActionControllerProvider.notifier)
        .resetPassword(_emailController.text.trim());

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? l10n.authResetSent),
      ),
    );
  }

  AppLocalizations get _l10n => AppLocalizations.of(context)!;
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
