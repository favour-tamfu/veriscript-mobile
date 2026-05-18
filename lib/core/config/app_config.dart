import 'package:flutter/foundation.dart';

const _defaultSupabaseUrl = 'https://wzplvgcqopecyhaikqwn.supabase.co';
const _defaultSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6cGx2Z2Nxb3BlY3loYWlrcXduIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMDY2NjYsImV4cCI6MjA5NDY4MjY2Nn0.ES60IfA2O8PckJ44vb53j-VIrkjyp4f4zy_O1yVsLA8';
const _defaultConverterEndpoint =
    'https://wzplvgcqopecyhaikqwn.functions.supabase.co/convert-document';

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
    final supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    final nextSupabaseUrl = String.fromEnvironment('NEXT_PUBLIC_SUPABASE_URL');
    final supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    final nextSupabaseAnonKey =
        String.fromEnvironment('NEXT_PUBLIC_SUPABASE_ANON_KEY');

    return AppConfig(
      supabaseUrl: supabaseUrl.isNotEmpty
          ? supabaseUrl
          : (nextSupabaseUrl.isNotEmpty ? nextSupabaseUrl : _defaultSupabaseUrl),
      supabaseAnonKey:
          supabaseAnonKey.isNotEmpty
              ? supabaseAnonKey
              : (nextSupabaseAnonKey.isNotEmpty
                    ? nextSupabaseAnonKey
                    : _defaultSupabaseAnonKey),
      revenueCatAndroidKey: String.fromEnvironment('REVENUECAT_ANDROID_KEY'),
      revenueCatAppleKey: String.fromEnvironment('REVENUECAT_APPLE_KEY'),
      sentryDsn: String.fromEnvironment('SENTRY_DSN'),
      converterEndpoint: String.fromEnvironment('CONVERTER_ENDPOINT').isNotEmpty
          ? String.fromEnvironment('CONVERTER_ENDPOINT')
          : _defaultConverterEndpoint,
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
