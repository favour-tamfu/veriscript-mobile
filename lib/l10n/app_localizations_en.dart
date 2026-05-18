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
  String get authCreateTitle => 'Create your VeriScript account';

  @override
  String get authBody =>
      'Use your email to access your scans, conversions, and synced document history.';

  @override
  String get authCreateBody =>
      'Start with email sign-in and sync your document tools across devices.';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get createAccount => 'Create account';

  @override
  String get switchToSignIn => 'Already have an account? Sign in';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get authEmailError => 'Enter a valid email address.';

  @override
  String get authPasswordError => 'Use at least 6 characters.';

  @override
  String get authResetNeedsEmail =>
      'Enter your email first to request a reset.';

  @override
  String get authResetSent =>
      'If the account exists, a reset link has been sent.';

  @override
  String get authHint =>
      'Supabase authentication and password reset can plug into this screen next.';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get homeGreeting => 'Welcome back';

  @override
  String get homeSubtitle => 'Your integrity and productivity tools are ready.';

  @override
  String homeSubtitleWithEmail(Object email) {
    return 'Signed in as $email. Your integrity and productivity tools are ready.';
  }

  @override
  String get featurePlagiarism => 'Plagiarism';

  @override
  String get featureOcr => 'OCR';

  @override
  String get featureTranslate => 'Translate';

  @override
  String get featureOffline => 'Offline';

  @override
  String get openConverter => 'Converter';

  @override
  String get openLibrary => 'Library';

  @override
  String get openPlans => 'Plans';

  @override
  String get toolPlagiarismTitle => 'Plagiarism check';

  @override
  String get toolPlagiarismBody => 'Compare drafts before submission.';

  @override
  String get toolConversionTitle => 'File conversion';

  @override
  String get toolConversionBody =>
      'Convert PDF, DOCX, and TXT with low-data feedback.';

  @override
  String get toolTranslationTitle => 'Translation';

  @override
  String get toolTranslationBody =>
      'English and French workflows with 100+ target languages.';

  @override
  String get toolOfflineTitle => 'Offline vault';

  @override
  String get toolOfflineBody =>
      'Keep recent documents available without a connection.';

  @override
  String get recentDocuments => 'Recent documents';

  @override
  String get converterTitle => 'File converter';

  @override
  String get converterBody =>
      'Queue files for conversion and keep the request history offline.';

  @override
  String get converterSetupNotice =>
      'Set CONVERTER_ENDPOINT in .env.local to send files to your conversion backend.';

  @override
  String get converterTargetFormat => 'Target format';

  @override
  String get converterPickFile => 'Pick a file to convert';

  @override
  String get libraryTitle => 'Offline document library';

  @override
  String get libraryBody =>
      'Saved conversions and sync metadata stay available even when the network is weak.';

  @override
  String get libraryEmpty => 'No documents have been saved yet.';

  @override
  String get paywallTitle => 'VeriScript Plus';

  @override
  String get paywallBody =>
      'Unlock higher limits for conversion, OCR, translation, and offline access.';

  @override
  String get paywallNoPackages =>
      'No live packages are available yet. Add offerings in RevenueCat to enable purchases.';

  @override
  String get paywallUnlock => 'Unlock Plus';

  @override
  String get paywallRestore => 'Restore purchases';
}
