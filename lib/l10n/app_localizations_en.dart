// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingTitle =>
      'Document tools built for real campus workflows';

  @override
  String get onboardingBody =>
      'Check originality, scan pages, convert files, and keep key documents offline without wasting mobile data.';

  @override
  String get getStarted => 'Get started';

  @override
  String get authTitle => 'Sign in to continue';

  @override
  String get authBody =>
      'Use your email to access your scans, conversions, and synced document history.';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get authHint =>
      'Supabase authentication and password reset can plug into this screen next.';

  @override
  String get homeGreeting => 'Welcome back';

  @override
  String get homeSubtitle => 'Your integrity and productivity tools are ready.';
}
