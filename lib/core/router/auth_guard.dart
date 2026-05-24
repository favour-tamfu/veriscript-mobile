import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_routes.dart';

String? authGuardRedirect(GoRouterState state) {
  final session = Supabase.instance.client.auth.currentSession;
  final path = state.matchedLocation;
  const publicPaths = <String>{
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
  };

  if (path == AppRoutes.splash) {
    return null;
  }

  if (session == null && !publicPaths.contains(path)) {
    return AppRoutes.login;
  }

  if (session != null && path.startsWith('/auth/')) {
    return AppRoutes.home;
  }

  return null;
}
