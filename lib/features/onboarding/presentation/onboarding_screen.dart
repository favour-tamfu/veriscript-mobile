import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import 'onboarding_page_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel(
      lottieAsset: 'assets/animations/splash.json',
      titleKey: 'onboardingTitle1',
      bodyKey: 'onboardingBody1',
    ),
    OnboardingPageModel(
      lottieAsset: 'assets/animations/loading.json',
      titleKey: 'onboardingTitle2',
      bodyKey: 'onboardingBody2',
    ),
    OnboardingPageModel(
      lottieAsset: 'assets/animations/empty.json',
      titleKey: 'onboardingTitle3',
      bodyKey: 'onboardingBody3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeAndGo(String route) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('onboarding_done', true);
    if (mounted) {
      context.go(route);
    }
  }

  void _goToNextPage() {
    if (_currentIndex >= _pages.length - 1) {
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final page = _pages[_currentIndex];
    final title = _resolveCopy(page.titleKey, isFrench);
    final body = _resolveCopy(page.bodyKey, isFrench);

    return Scaffold(
      backgroundColor: AppColors.vsBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: _currentIndex < 2
                    ? TextButton(
                        onPressed: () => _completeAndGo(AppRoutes.register),
                        child: Text(isFrench ? 'Passer' : 'Skip'),
                      )
                    : const SizedBox(height: 48),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(item.lottieAsset, width: 220, height: 220),
                        const SizedBox(height: 32),
                        Text(
                          _resolveCopy(item.titleKey, isFrench),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.vsPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _resolveCopy(item.bodyKey, isFrench),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.vsGray,
                                height: 1.5,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.vsAccent
                          : AppColors.vsGray,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_currentIndex < 2)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _goToNextPage,
                    child: Text(isFrench ? 'Suivant' : 'Next'),
                  ),
                )
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _completeAndGo(AppRoutes.register),
                        child: Text(
                          isFrench
                              ? 'Commencer gratuitement'
                              : 'Get Started Free',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _completeAndGo(AppRoutes.login),
                      child: Text(
                        isFrench
                            ? 'Déjà un compte? Se connecter'
                            : 'Already have an account? Sign in',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _resolveCopy(String key, bool isFrench) {
  switch (key) {
    case 'onboardingTitle1':
      return isFrench
          ? 'Détectez le plagiat instantanément'
          : 'Check for Plagiarism Instantly';
    case 'onboardingBody1':
      return isFrench
          ? 'Analysez tout document contre des milliards de sources. Obtenez des rapports en quelques secondes.'
          : 'Scan any document against billions of sources. Get detailed reports in seconds.';
    case 'onboardingTitle2':
      return isFrench
          ? 'Convertissez, Traduisez et Numérisez'
          : 'Convert, Translate & Scan';
    case 'onboardingBody2':
      return isFrench
          ? 'PDF vers Word, traduction en 100+ langues, numérisation OCR — tout en une application.'
          : 'PDF to Word, 100+ language translation, and OCR scanning — all in one app.';
    case 'onboardingTitle3':
      return isFrench
          ? 'Conçu pour les étudiants au Cameroun'
          : 'Built for Students in Cameroon';
    case 'onboardingBody3':
      return isFrench
          ? 'Rejoignez des milliers d\'étudiants dans les universités du Cameroun. Commencez gratuitement.'
          : 'Join thousands of students at universities across Cameroon. Start free today.';
    default:
      return '';
  }
}
