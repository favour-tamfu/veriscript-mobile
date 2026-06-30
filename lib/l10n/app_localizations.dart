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

  /// No description provided for @registerReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral code (optional)'**
  String get registerReferralCode;

  /// No description provided for @registerReferralCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a friend\'s referral code'**
  String get registerReferralCodeHint;

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

  /// No description provided for @homeBonusScans.
  ///
  /// In en, this message translates to:
  /// **'{count} bonus scans available'**
  String homeBonusScans(int count);

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

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Plagiarism Check'**
  String get scannerTitle;

  /// No description provided for @scannerSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a document'**
  String get scannerSelectFile;

  /// No description provided for @scannerMimeTypes.
  ///
  /// In en, this message translates to:
  /// **'PDF, DOCX, TXT · Max 20MB'**
  String get scannerMimeTypes;

  /// No description provided for @scannerDataWarning.
  ///
  /// In en, this message translates to:
  /// **'Large file — this may use significant mobile data'**
  String get scannerDataWarning;

  /// No description provided for @scannerScanButton.
  ///
  /// In en, this message translates to:
  /// **'Start Scan'**
  String get scannerScanButton;

  /// No description provided for @scannerScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning your document...'**
  String get scannerScanning;

  /// No description provided for @scannerDone.
  ///
  /// In en, this message translates to:
  /// **'Scan complete!'**
  String get scannerDone;

  /// No description provided for @scannerQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'Monthly scan limit reached'**
  String get scannerQuotaExceeded;

  /// No description provided for @scannerQuotaUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro for unlimited scans'**
  String get scannerQuotaUpgrade;

  /// No description provided for @scanResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Report'**
  String get scanResultTitle;

  /// No description provided for @scanResultSimilarity.
  ///
  /// In en, this message translates to:
  /// **'Similarity'**
  String get scanResultSimilarity;

  /// No description provided for @scanResultOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get scanResultOriginal;

  /// No description provided for @scanResultSources.
  ///
  /// In en, this message translates to:
  /// **'Matching Sources'**
  String get scanResultSources;

  /// No description provided for @scanResultNoSources.
  ///
  /// In en, this message translates to:
  /// **'No matching sources found'**
  String get scanResultNoSources;

  /// No description provided for @scanResultExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get scanResultExportPdf;

  /// No description provided for @scanResultShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get scanResultShare;

  /// No description provided for @scanResultLow.
  ///
  /// In en, this message translates to:
  /// **'Low similarity — content appears original'**
  String get scanResultLow;

  /// No description provided for @scanResultMedium.
  ///
  /// In en, this message translates to:
  /// **'Moderate similarity — review matching sources'**
  String get scanResultMedium;

  /// No description provided for @scanResultHigh.
  ///
  /// In en, this message translates to:
  /// **'High similarity — potential plagiarism detected'**
  String get scanResultHigh;

  /// No description provided for @ocrTitle.
  ///
  /// In en, this message translates to:
  /// **'OCR Scanner'**
  String get ocrTitle;

  /// No description provided for @ocrSelectSource.
  ///
  /// In en, this message translates to:
  /// **'Choose image source'**
  String get ocrSelectSource;

  /// No description provided for @ocrCamera.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get ocrCamera;

  /// No description provided for @ocrGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get ocrGallery;

  /// No description provided for @ocrProcessing.
  ///
  /// In en, this message translates to:
  /// **'Extracting text...'**
  String get ocrProcessing;

  /// No description provided for @ocrNoText.
  ///
  /// In en, this message translates to:
  /// **'No text found in image'**
  String get ocrNoText;

  /// No description provided for @ocrCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get ocrCopy;

  /// No description provided for @ocrScanForPlagiarism.
  ///
  /// In en, this message translates to:
  /// **'Scan for Plagiarism'**
  String get ocrScanForPlagiarism;

  /// No description provided for @ocrTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get ocrTranslate;

  /// No description provided for @ocrScanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan Another'**
  String get ocrScanAgain;

  /// No description provided for @ocrEditText.
  ///
  /// In en, this message translates to:
  /// **'Edit text'**
  String get ocrEditText;

  /// No description provided for @translatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get translatorTitle;

  /// No description provided for @translatorInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter text to translate...'**
  String get translatorInputHint;

  /// No description provided for @translatorSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap languages'**
  String get translatorSwap;

  /// No description provided for @translatorAuto.
  ///
  /// In en, this message translates to:
  /// **'Detect language'**
  String get translatorAuto;

  /// No description provided for @translatorFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get translatorFrom;

  /// No description provided for @translatorTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get translatorTo;

  /// No description provided for @translatorCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy translation'**
  String get translatorCopy;

  /// No description provided for @translatorCharsUsed.
  ///
  /// In en, this message translates to:
  /// **'{used} / {limit} characters used this month'**
  String translatorCharsUsed(int used, int limit);

  /// No description provided for @translatorQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'Monthly translation limit reached'**
  String get translatorQuotaExceeded;

  /// No description provided for @translatorSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get translatorSelectLanguage;

  /// No description provided for @translatorSearch.
  ///
  /// In en, this message translates to:
  /// **'Search languages...'**
  String get translatorSearch;

  /// No description provided for @translatorPrioritySection.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get translatorPrioritySection;

  /// No description provided for @translatorAllSection.
  ///
  /// In en, this message translates to:
  /// **'All languages'**
  String get translatorAllSection;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historySearch.
  ///
  /// In en, this message translates to:
  /// **'Search documents...'**
  String get historySearch;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get historyEmpty;

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your scanned and converted documents will appear here'**
  String get historyEmptySubtitle;

  /// No description provided for @historyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAll;

  /// No description provided for @historyFilterScans.
  ///
  /// In en, this message translates to:
  /// **'Scans'**
  String get historyFilterScans;

  /// No description provided for @historyFilterConversions.
  ///
  /// In en, this message translates to:
  /// **'Conversions'**
  String get historyFilterConversions;

  /// No description provided for @historyFilterTranslations.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get historyFilterTranslations;

  /// No description provided for @historyFilterOcr.
  ///
  /// In en, this message translates to:
  /// **'OCR'**
  String get historyFilterOcr;

  /// No description provided for @historySort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get historySort;

  /// No description provided for @historySortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get historySortNewest;

  /// No description provided for @historySortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get historySortOldest;

  /// No description provided for @historyStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get historyStatusDone;

  /// No description provided for @historyStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get historyStatusFailed;

  /// No description provided for @historyStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get historyStatusPending;

  /// No description provided for @historyDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this document?'**
  String get historyDeleteConfirm;

  /// No description provided for @historyDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove the file and all associated data. This cannot be undone.'**
  String get historyDeleteBody;

  /// No description provided for @historyCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get historyCancel;

  /// No description provided for @historyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDelete;

  /// No description provided for @historyDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get historyDeletedMessage;

  /// No description provided for @historyUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get historyUndo;

  /// No description provided for @driveTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get driveTitle;

  /// No description provided for @driveConnectDesc.
  ///
  /// In en, this message translates to:
  /// **'Import and export documents from your Google Drive'**
  String get driveConnectDesc;

  /// No description provided for @driveConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect with Google'**
  String get driveConnect;

  /// No description provided for @driveSignOut.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get driveSignOut;

  /// No description provided for @driveImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get driveImport;

  /// No description provided for @driveEmpty.
  ///
  /// In en, this message translates to:
  /// **'No documents found'**
  String get driveEmpty;

  /// No description provided for @driveEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'PDF, DOCX, and TXT files from your Drive will appear here'**
  String get driveEmptySubtitle;

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

  /// No description provided for @settingsGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get settingsGoogleDrive;

  /// No description provided for @settingsGoogleDriveDesc.
  ///
  /// In en, this message translates to:
  /// **'Import & export documents'**
  String get settingsGoogleDriveDesc;

  /// No description provided for @settingsReferralTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend'**
  String get settingsReferralTitle;

  /// No description provided for @settingsReferralDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your code and both of you get 2 bonus scans!'**
  String get settingsReferralDesc;

  /// No description provided for @settingsReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Your referral code'**
  String get settingsReferralCode;

  /// No description provided for @settingsCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get settingsCopyCode;

  /// No description provided for @settingsCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied!'**
  String get settingsCodeCopied;

  /// No description provided for @settingsReferralShare.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get settingsReferralShare;

  /// No description provided for @settingsReferralFriends.
  ///
  /// In en, this message translates to:
  /// **'{count} friends joined'**
  String settingsReferralFriends(int count);

  /// No description provided for @settingsBonusScans.
  ///
  /// In en, this message translates to:
  /// **'+{count} bonus scans'**
  String settingsBonusScans(int count);

  /// No description provided for @notifScanCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan complete'**
  String get notifScanCompleteTitle;

  /// No description provided for @notifScanCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Your plagiarism report is ready'**
  String get notifScanCompleteBody;

  /// No description provided for @notifConversionCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversion complete'**
  String get notifConversionCompleteTitle;

  /// No description provided for @notifConversionCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Your file is ready to download'**
  String get notifConversionCompleteBody;

  /// No description provided for @notifTranslationCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Translation complete'**
  String get notifTranslationCompleteTitle;

  /// No description provided for @notifSyncCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync complete'**
  String get notifSyncCompleteTitle;

  /// No description provided for @notifSyncCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'{count} items synced'**
  String notifSyncCompleteBody(int count);

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
