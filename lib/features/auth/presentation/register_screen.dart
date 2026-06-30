import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/auth_failure.dart';
import '../../referral/data/referral_repository.dart';
import 'auth_notifier.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _referralController = TextEditingController();

  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _termsRecognizer = TapGestureRecognizer();
  final _privacyRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _referralController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      return;
    }

    try {
      await ref.read(authNotifierProvider.notifier).signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
          );

      // Apply referral code if provided
      final referralCode = _referralController.text.trim();
      if (referralCode.isNotEmpty) {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          await ref
              .read(referralRepositoryProvider)
              .applyReferralCode(referralCode, userId)
              .catchError((_) => false);
        }
      }

      if (!mounted) {
        return;
      }

      final isFrench = Localizations.localeOf(context).languageCode == 'fr';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.vsSuccess,
          content: Text(
            isFrench
                ? 'Vérifiez votre email pour confirmer votre compte'
                : 'Check your email to confirm your account',
          ),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final strength = _passwordStrength(_passwordController.text);

    return Scaffold(
      backgroundColor: AppColors.vsBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  _AuthHeader(
                    title: 'VeriScript',
                    subtitle: isFrench ? 'Créer un compte' : 'Create Account',
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isFrench ? 'Créer un compte' : 'Create Account',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: isFrench ? 'Nom complet' : 'Full Name',
                              ),
                              validator: (value) {
                                if ((value ?? '').trim().isEmpty) {
                                  return isFrench
                                      ? 'Entrez votre nom complet'
                                      : 'Enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: isFrench ? 'Adresse e-mail' : 'Email address',
                              ),
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                final valid = RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(email);
                                if (email.isEmpty || !valid) {
                                  return isFrench
                                      ? 'Entrez une adresse e-mail valide'
                                      : 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: isFrench ? 'Mot de passe' : 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if ((value ?? '').length < 8) {
                                  return isFrench
                                      ? 'Le mot de passe doit comporter au moins 8 caractères'
                                      : 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                minHeight: 6,
                                value: strength.value,
                                backgroundColor: AppColors.vsLightGray,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  strength.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: isFrench
                                    ? 'Confirmer le mot de passe'
                                    : 'Confirm password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return isFrench
                                      ? 'Les mots de passe ne correspondent pas'
                                      : 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _referralController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                labelText: isFrench
                                    ? 'Code de parrainage (optionnel)'
                                    : 'Referral code (optional)',
                                hintText: isFrench
                                    ? 'Entrez le code d\'un ami'
                                    : 'Enter a friend\'s referral code',
                                prefixIcon: const Icon(Icons.card_giftcard_rounded),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) =>
                                      setState(() => _acceptTerms = value ?? false),
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: isFrench
                                              ? 'J\'accepte les '
                                              : 'I agree to the ',
                                        ),
                                        TextSpan(
                                          text: isFrench
                                              ? 'Conditions d\'utilisation'
                                              : 'Terms & Conditions',
                                          style: const TextStyle(
                                            color: AppColors.vsAccent,
                                            decoration: TextDecoration.underline,
                                            decorationColor: AppColors.vsAccent,
                                          ),
                                          recognizer: _termsRecognizer
                                            ..onTap = () => launchUrl(
                                                  Uri.parse(
                                                    'https://favour-tamfu.github.io/Veriscript-legal/terms-and-conditions',
                                                  ),
                                                  mode: LaunchMode.externalApplication,
                                                ),
                                        ),
                                        TextSpan(
                                          text: isFrench ? ' et la ' : ' and ',
                                        ),
                                        TextSpan(
                                          text: isFrench
                                              ? 'Politique de confidentialité'
                                              : 'Privacy Policy',
                                          style: const TextStyle(
                                            color: AppColors.vsAccent,
                                            decoration: TextDecoration.underline,
                                            decorationColor: AppColors.vsAccent,
                                          ),
                                          recognizer: _privacyRecognizer
                                            ..onTap = () => launchUrl(
                                                  Uri.parse(
                                                    'https://favour-tamfu.github.io/Veriscript-legal/privacy-policy',
                                                  ),
                                                  mode: LaunchMode.externalApplication,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading || !_acceptTerms ? null : _submit,
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
                                        isFrench
                                            ? 'Créer un compte'
                                            : 'Create Account',
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () => context.push(AppRoutes.login),
                                child: Text(
                                  isFrench
                                      ? 'Déjà un compte? Se connecter'
                                      : 'Already have an account? Sign in',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

({double value, Color color}) _passwordStrength(String password) {
  if (password.length < 8) {
    return (value: 0.33, color: AppColors.vsError);
  }

  final hasUppercase = password.contains(RegExp(r'[A-Z]'));
  final hasNumber = password.contains(RegExp(r'[0-9]'));
  final hasSpecial = password.contains(RegExp(r'[^A-Za-z0-9]'));

  if (hasUppercase && hasNumber && hasSpecial) {
    return (value: 1.0, color: AppColors.vsSuccess);
  }

  return (value: 0.66, color: AppColors.vsWarning);
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.vsPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 3,
          color: AppColors.vsAccent,
        ),
        const SizedBox(height: 32),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
