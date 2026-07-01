// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'VeriScript';

  @override
  String get splashTagline => 'Document Integrity Suite';

  @override
  String get onboardingTitle1 => 'Check for Plagiarism Instantly';

  @override
  String get onboardingBody1 =>
      'Scan any document against billions of sources. Get detailed reports in seconds.';

  @override
  String get onboardingTitle2 => 'Convert, Translate & Scan';

  @override
  String get onboardingBody2 =>
      'PDF to Word, 100+ language translation, and OCR scanning — all in one app.';

  @override
  String get onboardingTitle3 => 'Built for Students in Cameroon';

  @override
  String get onboardingBody3 =>
      'Join thousands of students at universities across Cameroon. Start free today.';

  @override
  String get onboardingCta => 'Get Started Free';

  @override
  String get onboardingSignIn => 'Already have an account? Sign in';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginEmail => 'Email address';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginForgot => 'Forgot password?';

  @override
  String get loginNoAccount => 'Create account';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerName => 'Full Name';

  @override
  String get registerEmail => 'Email address';

  @override
  String get registerPassword => 'Password';

  @override
  String get registerConfirm => 'Confirm password';

  @override
  String get registerReferralCode => 'Referral code (optional)';

  @override
  String get registerReferralCodeHint => 'Enter a friend\'s referral code';

  @override
  String get registerButton => 'Create Account';

  @override
  String get registerTerms => 'I agree to the Terms of Service';

  @override
  String get registerSuccess => 'Check your email to confirm your account';

  @override
  String get forgotTitle => 'Reset Password';

  @override
  String get forgotEmail => 'Email address';

  @override
  String get forgotButton => 'Send Reset Link';

  @override
  String get forgotSuccess => 'Check your email for a reset link';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeSubtitle => 'What would you like to do today?';

  @override
  String get homeToolScanner => 'Plagiarism Check';

  @override
  String get homeToolScannerDesc => 'Scan for copied content';

  @override
  String get homeToolConverter => 'File Converter';

  @override
  String get homeToolConverterDesc => 'PDF, DOCX, TXT';

  @override
  String get homeToolOcr => 'OCR Scanner';

  @override
  String get homeToolOcrDesc => 'Scan physical docs';

  @override
  String get homeToolTranslator => 'Translator';

  @override
  String get homeToolTranslatorDesc => '100+ languages';

  @override
  String get homeRecentDocs => 'Recent Documents';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeEmptyDocs => 'No documents yet';

  @override
  String get homeEmptyDocsSubtitle => 'Upload your first document!';

  @override
  String get homeUploadFirst => 'Upload Document';

  @override
  String get homeShareLabel => 'Share VeriScript with your class';

  @override
  String get homeShareButton => 'Share on WhatsApp';

  @override
  String get homeShareText =>
      'Check out VeriScript — plagiarism detection + file conversion for students in Cameroon! Download: https://play.google.com/store/apps/details?id=com.veriscipt.mobile';

  @override
  String get homeMonthlyUsage => 'Monthly Usage';

  @override
  String get homeFreePlan => 'Free plan';

  @override
  String get homeUpgradeNudge => 'Upgrade — unlimited access';

  @override
  String homeBonusScans(int count) {
    return '$count bonus scans available';
  }

  @override
  String get converterTitle => 'File Converter';

  @override
  String get converterSelectFile => 'Tap to select a file';

  @override
  String get converterFileTypes => 'PDF, DOCX, TXT · Max 10MB';

  @override
  String get converterLargeFile =>
      'Large file — this may use significant mobile data';

  @override
  String get converterConvertTo => 'Convert to:';

  @override
  String get converterChooseDifferent => 'Choose different file';

  @override
  String get converterButton => 'Convert Now';

  @override
  String converterFreeRemaining(int used, int max) {
    return '$used of $max free conversions remaining this month';
  }

  @override
  String get converterUploading => 'Uploading your file...';

  @override
  String get converterConverting => 'Converting your document...';

  @override
  String get converterDone => 'Conversion complete!';

  @override
  String get converterDownload => 'Download File';

  @override
  String get converterAnother => 'Convert Another';

  @override
  String get scannerTitle => 'Plagiarism Check';

  @override
  String get scannerSelectFile => 'Tap to select a document';

  @override
  String get scannerMimeTypes => 'PDF, DOCX, TXT · Max 20MB';

  @override
  String get scannerDataWarning =>
      'Large file — this may use significant mobile data';

  @override
  String get scannerScanButton => 'Start Scan';

  @override
  String get scannerScanning => 'Scanning your document...';

  @override
  String get scannerDone => 'Scan complete!';

  @override
  String get scannerQuotaExceeded => 'Monthly scan limit reached';

  @override
  String get scannerQuotaUpgrade => 'Upgrade to Pro for unlimited scans';

  @override
  String get scanResultTitle => 'Scan Report';

  @override
  String get scanResultSimilarity => 'Similarity';

  @override
  String get scanResultOriginal => 'Original';

  @override
  String get scanResultSources => 'Matching Sources';

  @override
  String get scanResultNoSources => 'No matching sources found';

  @override
  String get scanResultExportPdf => 'Export PDF';

  @override
  String get scanResultShare => 'Share';

  @override
  String get scanResultLow => 'Low similarity — content appears original';

  @override
  String get scanResultMedium =>
      'Moderate similarity — review matching sources';

  @override
  String get scanResultHigh =>
      'High similarity — potential plagiarism detected';

  @override
  String get ocrTitle => 'OCR Scanner';

  @override
  String get ocrSelectSource => 'Choose image source';

  @override
  String get ocrCamera => 'Take Photo';

  @override
  String get ocrGallery => 'Choose from Gallery';

  @override
  String get ocrProcessing => 'Extracting text...';

  @override
  String get ocrNoText => 'No text found in image';

  @override
  String get ocrCopy => 'Copy Text';

  @override
  String get ocrScanForPlagiarism => 'Scan for Plagiarism';

  @override
  String get ocrTranslate => 'Translate';

  @override
  String get ocrScanAgain => 'Scan Another';

  @override
  String get ocrEditText => 'Edit text';

  @override
  String get translatorTitle => 'Translator';

  @override
  String get translatorInputHint => 'Enter text to translate...';

  @override
  String get translatorSwap => 'Swap languages';

  @override
  String get translatorAuto => 'Detect language';

  @override
  String get translatorFrom => 'From';

  @override
  String get translatorTo => 'To';

  @override
  String get translatorCopy => 'Copy translation';

  @override
  String translatorCharsUsed(int used, int limit) {
    return '$used / $limit characters used this month';
  }

  @override
  String get translatorQuotaExceeded => 'Monthly translation limit reached';

  @override
  String get translatorSelectLanguage => 'Select language';

  @override
  String get translatorSearch => 'Search languages...';

  @override
  String get translatorPrioritySection => 'Suggested';

  @override
  String get translatorAllSection => 'All languages';

  @override
  String get historyTitle => 'History';

  @override
  String get historySearch => 'Search documents...';

  @override
  String get historyEmpty => 'No history yet';

  @override
  String get historyEmptySubtitle =>
      'Your scanned and converted documents will appear here';

  @override
  String get historyFilterAll => 'All';

  @override
  String get historyFilterScans => 'Scans';

  @override
  String get historyFilterConversions => 'Conversions';

  @override
  String get historyFilterTranslations => 'Translations';

  @override
  String get historyFilterOcr => 'OCR';

  @override
  String get historySort => 'Sort';

  @override
  String get historySortNewest => 'Newest first';

  @override
  String get historySortOldest => 'Oldest first';

  @override
  String get historyStatusDone => 'Done';

  @override
  String get historyStatusFailed => 'Failed';

  @override
  String get historyStatusPending => 'Pending';

  @override
  String get historyDeleteConfirm => 'Delete this document?';

  @override
  String get historyDeleteBody =>
      'This will remove the file and all associated data. This cannot be undone.';

  @override
  String get historyCancel => 'Cancel';

  @override
  String get historyDelete => 'Delete';

  @override
  String get historyDeletedMessage => 'Document deleted';

  @override
  String get historyUndo => 'Undo';

  @override
  String get driveTitle => 'Google Drive';

  @override
  String get driveConnectDesc =>
      'Import and export documents from your Google Drive';

  @override
  String get driveConnect => 'Connect with Google';

  @override
  String get driveSignOut => 'Disconnect';

  @override
  String get driveImport => 'Import';

  @override
  String get driveEmpty => 'No documents found';

  @override
  String get driveEmptySubtitle =>
      'PDF, DOCX, and TXT files from your Drive will appear here';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language / Langue';

  @override
  String get settingsGoogleDrive => 'Google Drive';

  @override
  String get settingsGoogleDriveDesc => 'Import & export documents';

  @override
  String get settingsReferralTitle => 'Refer a Friend';

  @override
  String get settingsReferralDesc =>
      'Share your code and both of you get 2 bonus scans!';

  @override
  String get settingsReferralCode => 'Your referral code';

  @override
  String get settingsCopyCode => 'Copy code';

  @override
  String get settingsCodeCopied => 'Code copied!';

  @override
  String get settingsReferralShare => 'Share on WhatsApp';

  @override
  String settingsReferralFriends(int count) {
    return '$count friends joined';
  }

  @override
  String settingsBonusScans(int count) {
    return '+$count bonus scans';
  }

  @override
  String get notifScanCompleteTitle => 'Scan complete';

  @override
  String get notifScanCompleteBody => 'Your plagiarism report is ready';

  @override
  String get notifConversionCompleteTitle => 'Conversion complete';

  @override
  String get notifConversionCompleteBody => 'Your file is ready to download';

  @override
  String get notifTranslationCompleteTitle => 'Translation complete';

  @override
  String get notifSyncCompleteTitle => 'Sync complete';

  @override
  String notifSyncCompleteBody(int count) {
    return '$count items synced';
  }

  @override
  String get errorNetworkTitle => 'No connection';

  @override
  String get errorNetworkBody => 'Check your internet and try again.';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorRetry => 'Try again';

  @override
  String get offlineBanner => 'You are offline — showing cached data';

  @override
  String get stubComingSoon => 'Coming in Phase 2';

  @override
  String get authErrorInvalidCredentials => 'Invalid email or password';

  @override
  String get authErrorEmailInUse => 'An account already exists with this email';

  @override
  String get authErrorWeakPassword => 'Password must be at least 8 characters';

  @override
  String get authErrorNetwork => 'No connection. Check your internet.';

  @override
  String get authErrorUnknown => 'Something went wrong. Please try again.';
}
