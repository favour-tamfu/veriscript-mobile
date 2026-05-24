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

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'VeriScript'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Document Integrity Suite'**
  String get splashTagline;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Check for Plagiarism Instantly'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Scan any document against billions of sources. Get detailed reports in seconds.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Convert, Translate & Scan'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'PDF to Word, 100+ language translation, and OCR scanning — all in one app.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Built for Students in Cameroon'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of students at universities across Cameroon. Start free today.'**
  String get onboardingBody3;

  /// No description provided for @onboardingCta.
  ///
  /// In en, this message translates to:
  /// **'Get Started Free'**
  String get onboardingCta;

  /// No description provided for @onboardingSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get onboardingSignIn;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgot;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginNoAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get registerName;

  /// No description provided for @registerEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get registerEmail;

  /// No description provided for @registerPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPassword;

  /// No description provided for @registerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirm;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @registerTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service'**
  String get registerTerms;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm your account'**
  String get registerSuccess;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotTitle;

  /// No description provided for @forgotEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get forgotEmail;

  /// No description provided for @forgotButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get forgotButton;

  /// No description provided for @forgotSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check your email for a reset link'**
  String get forgotSuccess;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do today?'**
  String get homeSubtitle;

  /// No description provided for @homeToolScanner.
  ///
  /// In en, this message translates to:
  /// **'Plagiarism Check'**
  String get homeToolScanner;

  /// No description provided for @homeToolScannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan for copied content'**
  String get homeToolScannerDesc;

  /// No description provided for @homeToolConverter.
  ///
  /// In en, this message translates to:
  /// **'File Converter'**
  String get homeToolConverter;

  /// No description provided for @homeToolConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'PDF, DOCX, TXT'**
  String get homeToolConverterDesc;

  /// No description provided for @homeToolOcr.
  ///
  /// In en, this message translates to:
  /// **'OCR Scanner'**
  String get homeToolOcr;

  /// No description provided for @homeToolOcrDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan physical docs'**
  String get homeToolOcrDesc;

  /// No description provided for @homeToolTranslator.
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get homeToolTranslator;

  /// No description provided for @homeToolTranslatorDesc.
  ///
  /// In en, this message translates to:
  /// **'100+ languages'**
  String get homeToolTranslatorDesc;

  /// No description provided for @homeRecentDocs.
  ///
  /// In en, this message translates to:
  /// **'Recent Documents'**
  String get homeRecentDocs;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeEmptyDocs.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get homeEmptyDocs;

  /// No description provided for @homeEmptyDocsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your first document!'**
  String get homeEmptyDocsSubtitle;

  /// No description provided for @homeUploadFirst.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get homeUploadFirst;

  /// No description provided for @homeShareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share VeriScript with your class'**
  String get homeShareLabel;

  /// No description provided for @homeShareButton.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get homeShareButton;

  /// No description provided for @homeShareText.
  ///
  /// In en, this message translates to:
  /// **'Check out VeriScript — plagiarism detection + file conversion for students in Cameroon! Download: https://play.google.com/store/apps/details?id=com.veriscipt.mobile'**
  String get homeShareText;

  /// No description provided for @homeMonthlyUsage.
  ///
  /// In en, this message translates to:
  /// **'Monthly Usage'**
  String get homeMonthlyUsage;

  /// No description provided for @homeFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get homeFreePlan;

  /// No description provided for @homeUpgradeNudge.
  ///
  /// In en, this message translates to:
  /// **'Upgrade — unlimited access'**
  String get homeUpgradeNudge;

  /// No description provided for @converterTitle.
  ///
  /// In en, this message translates to:
  /// **'File Converter'**
  String get converterTitle;

  /// No description provided for @converterSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a file'**
  String get converterSelectFile;

  /// No description provided for @converterFileTypes.
  ///
  /// In en, this message translates to:
  /// **'PDF, DOCX, TXT · Max 10MB'**
  String get converterFileTypes;

  /// No description provided for @converterLargeFile.
  ///
  /// In en, this message translates to:
  /// **'Large file — this may use significant mobile data'**
  String get converterLargeFile;

  /// No description provided for @converterConvertTo.
  ///
  /// In en, this message translates to:
  /// **'Convert to:'**
  String get converterConvertTo;

  /// No description provided for @converterChooseDifferent.
  ///
  /// In en, this message translates to:
  /// **'Choose different file'**
  String get converterChooseDifferent;

  /// No description provided for @converterButton.
  ///
  /// In en, this message translates to:
  /// **'Convert Now'**
  String get converterButton;

  /// No description provided for @converterFreeRemaining.
  ///
  /// In en, this message translates to:
  /// **'{used} of {max} free conversions remaining this month'**
  String converterFreeRemaining(int used, int max);

  /// No description provided for @converterUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading your file...'**
  String get converterUploading;

  /// No description provided for @converterConverting.
  ///
  /// In en, this message translates to:
  /// **'Converting your document...'**
  String get converterConverting;

  /// No description provided for @converterDone.
  ///
  /// In en, this message translates to:
  /// **'Conversion complete!'**
  String get converterDone;

  /// No description provided for @converterDownload.
  ///
  /// In en, this message translates to:
  /// **'Download File'**
  String get converterDownload;

  /// No description provided for @converterAnother.
  ///
  /// In en, this message translates to:
  /// **'Convert Another'**
  String get converterAnother;

  /// No description provided for @errorNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get errorNetworkTitle;

  /// No description provided for @errorNetworkBody.
  ///
  /// In en, this message translates to:
  /// **'Check your internet and try again.'**
  String get errorNetworkBody;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get errorRetry;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline — showing cached data'**
  String get offlineBanner;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language / Langue'**
  String get settingsLanguage;

  /// No description provided for @stubComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming in Phase 2'**
  String get stubComingSoon;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorUnknown;
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
