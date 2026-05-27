import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn = AppEnv.sentryDsn;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      final supabaseUrl = AppEnv.supabaseUrl;
      final supabaseAnonKey = AppEnv.supabaseAnonKey;

      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        runApp(const _StartupErrorApp(
          message:
              'Missing Supabase credentials.\nRun with:\n  flutter run --dart-define-from-file=.env.local',
        ));
        return;
      }

      try {
        await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      } catch (error, stack) {
        await Sentry.captureException(error, stackTrace: stack);
        runApp(_StartupErrorApp(message: 'Supabase init failed:\n$error'));
        return;
      }

      runApp(const ProviderScope(child: VeriScriptApp()));
    },
  );
}

/// Shown instead of a black screen when startup fails.
class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0F1E2D),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 64),
                const SizedBox(height: 24),
                const Text(
                  'VeriScript',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF6B7C8D), fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
