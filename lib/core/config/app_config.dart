import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.revenueCatAndroidKey,
    required this.revenueCatAppleKey,
    required this.sentryDsn,
    required this.converterEndpoint,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      revenueCatAndroidKey: String.fromEnvironment('REVENUECAT_ANDROID_KEY'),
      revenueCatAppleKey: String.fromEnvironment('REVENUECAT_APPLE_KEY'),
      sentryDsn: String.fromEnvironment('SENTRY_DSN'),
      converterEndpoint: String.fromEnvironment('CONVERTER_ENDPOINT'),
    );
  }

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String revenueCatAndroidKey;
  final String revenueCatAppleKey;
  final String sentryDsn;
  final String converterEndpoint;

  bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  bool get hasConverterEndpoint => converterEndpoint.isNotEmpty;

  bool get hasRevenueCat =>
      revenueCatAndroidKey.isNotEmpty || revenueCatAppleKey.isNotEmpty;

  String? get activeRevenueCatKey {
    if (kIsWeb) {
      return null;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return revenueCatAndroidKey.isEmpty ? null : revenueCatAndroidKey;
      case TargetPlatform.iOS:
        return revenueCatAppleKey.isEmpty ? null : revenueCatAppleKey;
      default:
        return null;
    }
  }
}
