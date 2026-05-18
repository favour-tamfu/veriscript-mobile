import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/converter/presentation/converter_screen.dart';
import '../../features/documents/presentation/document_library_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/subscription/presentation/paywall_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingControllerProvider);
  final authSession = ref.watch(authSessionProvider);

  return GoRouter(
    initialLocation: SplashScreen.routePath,
    redirect: (context, state) {
      final isLoading = onboardingState.isLoading || authSession.isLoading;
      final isSplash = state.matchedLocation == SplashScreen.routePath;
      final onboardingDone = onboardingState.value ?? false;
      final isSignedIn = authSession.value != null;

      if (isLoading) {
        return isSplash ? null : SplashScreen.routePath;
      }

      if (!onboardingDone) {
        return state.matchedLocation == OnboardingScreen.routePath
            ? null
            : OnboardingScreen.routePath;
      }

      if (!isSignedIn) {
        return state.matchedLocation == AuthScreen.routePath
            ? null
            : AuthScreen.routePath;
      }

      if (isSplash ||
          state.matchedLocation == OnboardingScreen.routePath ||
          state.matchedLocation == AuthScreen.routePath) {
        return HomeScreen.routePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingScreen.routePath,
        name: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AuthScreen.routePath,
        name: AuthScreen.routeName,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: HomeScreen.routePath,
        name: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: ConverterScreen.routePath,
        name: ConverterScreen.routeName,
        builder: (context, state) => const ConverterScreen(),
      ),
      GoRoute(
        path: DocumentLibraryScreen.routePath,
        name: DocumentLibraryScreen.routeName,
        builder: (context, state) => const DocumentLibraryScreen(),
      ),
      GoRoute(
        path: PaywallScreen.routePath,
        name: PaywallScreen.routeName,
        builder: (context, state) => const PaywallScreen(),
      ),
    ],
  );
});
