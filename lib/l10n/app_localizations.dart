import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Document tools built for real campus workflows'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'Check originality, scan pages, convert files, and keep key documents offline without wasting mobile data.'**
  String get onboardingBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authTitle;

  /// No description provided for @authCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your VeriScript account'**
  String get authCreateTitle;

  /// No description provided for @authBody.
  ///
  /// In en, this message translates to:
  /// **'Use your email to access your scans, conversions, and synced document history.'**
  String get authBody;

  /// No description provided for @authCreateBody.
  ///
  /// In en, this message translates to:
  /// **'Start with email sign-in and sync your document tools across devices.'**
  String get authCreateBody;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @switchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get switchToSignIn;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @authEmailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authEmailError;

  /// No description provided for @authPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get authPasswordError;

  /// No description provided for @authResetNeedsEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email first to request a reset.'**
  String get authResetNeedsEmail;

  /// No description provided for @authResetSent.
  ///
  /// In en, this message translates to:
  /// **'If the account exists, a reset link has been sent.'**
  String get authResetSent;

  /// No description provided for @authHint.
  ///
  /// In en, this message translates to:
  /// **'Supabase authentication and password reset can plug into this screen next.'**
  String get authHint;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeGreeting;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your integrity and productivity tools are ready.'**
  String get homeSubtitle;

  /// No description provided for @homeSubtitleWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}. Your integrity and productivity tools are ready.'**
  String homeSubtitleWithEmail(Object email);

  /// No description provided for @featurePlagiarism.
  ///
  /// In en, this message translates to:
  /// **'Plagiarism'**
  String get featurePlagiarism;

  /// No description provided for @featureOcr.
  ///
  /// In en, this message translates to:
  /// **'OCR'**
  String get featureOcr;

  /// No description provided for @featureTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get featureTranslate;

  /// No description provided for @featureOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get featureOffline;

  /// No description provided for @openConverter.
  ///
  /// In en, this message translates to:
  /// **'Converter'**
  String get openConverter;

  /// No description provided for @openLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get openLibrary;

  /// No description provided for @openPlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get openPlans;

  /// No description provided for @toolPlagiarismTitle.
  ///
  /// In en, this message translates to:
  /// **'Plagiarism check'**
  String get toolPlagiarismTitle;

  /// No description provided for @toolPlagiarismBody.
  ///
  /// In en, this message translates to:
  /// **'Compare drafts before submission.'**
  String get toolPlagiarismBody;

  /// No description provided for @toolConversionTitle.
  ///
  /// In en, this message translates to:
  /// **'File conversion'**
  String get toolConversionTitle;

  /// No description provided for @toolConversionBody.
  ///
  /// In en, this message translates to:
  /// **'Convert PDF, DOCX, and TXT with low-data feedback.'**
  String get toolConversionBody;

  /// No description provided for @toolTranslationTitle.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get toolTranslationTitle;

  /// No description provided for @toolTranslationBody.
  ///
  /// In en, this message translates to:
  /// **'English and French workflows with 100+ target languages.'**
  String get toolTranslationBody;

  /// No description provided for @toolOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline vault'**
  String get toolOfflineTitle;

  /// No description provided for @toolOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Keep recent documents available without a connection.'**
  String get toolOfflineBody;

  /// No description provided for @recentDocuments.
  ///
  /// In en, this message translates to:
  /// **'Recent documents'**
  String get recentDocuments;

  /// No description provided for @converterTitle.
  ///
  /// In en, this message translates to:
  /// **'File converter'**
  String get converterTitle;

  /// No description provided for @converterBody.
  ///
  /// In en, this message translates to:
  /// **'Queue files for conversion and keep the request history offline.'**
  String get converterBody;

  /// No description provided for @converterSetupNotice.
  ///
  /// In en, this message translates to:
  /// **'Set CONVERTER_ENDPOINT in .env.local to send files to your conversion backend.'**
  String get converterSetupNotice;

  /// No description provided for @converterTargetFormat.
  ///
  /// In en, this message translates to:
  /// **'Target format'**
  String get converterTargetFormat;

  /// No description provided for @converterPickFile.
  ///
  /// In en, this message translates to:
  /// **'Pick a file to convert'**
  String get converterPickFile;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline document library'**
  String get libraryTitle;

  /// No description provided for @libraryBody.
  ///
  /// In en, this message translates to:
  /// **'Saved conversions and sync metadata stay available even when the network is weak.'**
  String get libraryBody;

  /// No description provided for @libraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No documents have been saved yet.'**
  String get libraryEmpty;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'VeriScript Plus'**
  String get paywallTitle;

  /// No description provided for @paywallBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock higher limits for conversion, OCR, translation, and offline access.'**
  String get paywallBody;

  /// No description provided for @paywallNoPackages.
  ///
  /// In en, this message translates to:
  /// **'No live packages are available yet. Add offerings in RevenueCat to enable purchases.'**
  String get paywallNoPackages;

  /// No description provided for @paywallUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock Plus'**
  String get paywallUnlock;

  /// No description provided for @paywallRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get paywallRestore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
