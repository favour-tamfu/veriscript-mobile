import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  static const _splashDuration = Duration(seconds: 5);
  static const _entranceDuration = Duration(milliseconds: 1100);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: _entranceDuration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _redirectAfterDelay();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _redirectAfterDelay() async {
    await Future<void>.delayed(_splashDuration);
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
            FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 168,
                  height: 168,
                  semanticsLabel: 'VeriScript logo',
                ),
              ),
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
