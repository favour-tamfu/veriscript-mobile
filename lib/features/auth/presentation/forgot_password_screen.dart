import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/auth_failure.dart';
import 'auth_notifier.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  Timer? _cooldownTimer;
  int _secondsRemaining = 0;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _secondsRemaining > 0) {
      return;
    }

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .sendPasswordReset(_emailController.text.trim());
      if (!mounted) {
        return;
      }

      final isFrench = Localizations.localeOf(context).languageCode == 'fr';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.vsSuccess,
          content: Text(
            isFrench
                ? 'Vérifiez votre email pour le lien de réinitialisation'
                : 'Check your email for a reset link',
          ),
        ),
      );
      _startCooldown();
    } on AuthFailure catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.vsError,
          content: Text(error.message(Localizations.localeOf(context))),
        ),
      );
    }
  }

  void _startCooldown() {
    setState(() {
      _secondsRemaining = 60;
    });
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
        return;
      }

      setState(() {
        _secondsRemaining -= 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    return Scaffold(
      backgroundColor: AppColors.vsBackground,
      appBar: AppBar(
        title: Text(isFrench ? 'Réinitialiser le mot de passe' : 'Reset Password'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isFrench ? 'Réinitialiser le mot de passe' : 'Reset Password',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: isFrench ? 'Adresse e-mail' : 'Email address',
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(email);
                            if (email.isEmpty || !valid) {
                              return isFrench
                                  ? 'Entrez une adresse e-mail valide'
                                  : 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading || _secondsRemaining > 0
                                ? null
                                : _submit,
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.vsDark,
                                    ),
                                  )
                                : Text(
                                    _secondsRemaining > 0
                                        ? '${isFrench ? 'Réessayez dans' : 'Retry in'} $_secondsRemaining s'
                                        : isFrench
                                            ? 'Envoyer le lien'
                                            : 'Send Reset Link',
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
