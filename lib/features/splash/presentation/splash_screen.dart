import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirectAfterDelay();
  }

  Future<void> _redirectAfterDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 2800));
    if (!mounted) {
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      context.go(AppRoutes.home);
      return;
    }

    final preferences = await SharedPreferences.getInstance();
    final onboardingDone = preferences.getBool('onboarding_done') ?? false;

    if (!mounted) {
      return;
    }

    if (!onboardingDone) {
      context.go(AppRoutes.onboarding);
      return;
    }

    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final tagline = locale.languageCode == 'fr'
        ? 'Suite d\'intégrité documentaire'
        : 'Document Integrity Suite';

    return Scaffold(
      backgroundColor: AppColors.vsBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/splash.json',
              width: 200,
              height: 200,
              repeat: false,
            ),
            const SizedBox(height: 24),
            Text(
              'VeriScript',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.vsPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 3,
              color: AppColors.vsAccent,
            ),
            const SizedBox(height: 8),
            Text(
              tagline,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.vsGray,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
