class AppEnv {
  const AppEnv._();

  static String get supabaseUrl {
    const v = String.fromEnvironment('SUPABASE_URL');
    if (v.isNotEmpty) return v;
    const fallback = String.fromEnvironment('NEXT_PUBLIC_SUPABASE_URL');
    return fallback;
  }

  static String get supabaseAnonKey {
    const v = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (v.isNotEmpty) return v;
    const fallback = String.fromEnvironment('NEXT_PUBLIC_SUPABASE_ANON_KEY');
    return fallback;
  }

  static String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
}
