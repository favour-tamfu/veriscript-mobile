// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'VeriScript';

  @override
  String get splashTagline => 'Suite d\'intégrité documentaire';

  @override
  String get onboardingTitle1 => 'Détectez le plagiat instantanément';

  @override
  String get onboardingBody1 =>
      'Analysez tout document contre des milliards de sources. Obtenez des rapports en quelques secondes.';

  @override
  String get onboardingTitle2 => 'Convertissez, Traduisez et Numérisez';

  @override
  String get onboardingBody2 =>
      'PDF vers Word, traduction en 100+ langues, numérisation OCR — tout en une application.';

  @override
  String get onboardingTitle3 => 'Conçu pour les étudiants au Cameroun';

  @override
  String get onboardingBody3 =>
      'Rejoignez des milliers d\'étudiants dans les universités du Cameroun. Commencez gratuitement.';

  @override
  String get onboardingCta => 'Commencer gratuitement';

  @override
  String get onboardingSignIn => 'Déjà un compte? Se connecter';

  @override
  String get loginTitle => 'Bon retour';

  @override
  String get loginEmail => 'Adresse e-mail';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginForgot => 'Mot de passe oublié?';

  @override
  String get loginNoAccount => 'Créer un compte';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerName => 'Nom complet';

  @override
  String get registerEmail => 'Adresse e-mail';

  @override
  String get registerPassword => 'Mot de passe';

  @override
  String get registerConfirm => 'Confirmer le mot de passe';

  @override
  String get registerReferralCode => 'Code de parrainage (optionnel)';

  @override
  String get registerReferralCodeHint => 'Entrez le code d\'un ami';

  @override
  String get registerButton => 'Créer un compte';

  @override
  String get registerTerms => 'J\'accepte les conditions d\'utilisation';

  @override
  String get registerSuccess =>
      'Vérifiez votre email pour confirmer votre compte';

  @override
  String get forgotTitle => 'Réinitialiser le mot de passe';

  @override
  String get forgotEmail => 'Adresse e-mail';

  @override
  String get forgotButton => 'Envoyer le lien';

  @override
  String get forgotSuccess =>
      'Vérifiez votre email pour le lien de réinitialisation';

  @override
  String get homeGreetingMorning => 'Bonjour';

  @override
  String get homeGreetingAfternoon => 'Bon après-midi';

  @override
  String get homeGreetingEvening => 'Bonsoir';

  @override
  String get homeSubtitle => 'Que souhaitez-vous faire aujourd\'hui?';

  @override
  String get homeToolScanner => 'Vérif. de plagiat';

  @override
  String get homeToolScannerDesc => 'Analysez le contenu copié';

  @override
  String get homeToolConverter => 'Convertisseur';

  @override
  String get homeToolConverterDesc => 'PDF, DOCX, TXT';

  @override
  String get homeToolOcr => 'Numériseur OCR';

  @override
  String get homeToolOcrDesc => 'Numérisez des docs physiques';

  @override
  String get homeToolTranslator => 'Traducteur';

  @override
  String get homeToolTranslatorDesc => '100+ langues';

  @override
  String get homeRecentDocs => 'Documents récents';

  @override
  String get homeSeeAll => 'Voir tout';

  @override
  String get homeEmptyDocs => 'Aucun document';

  @override
  String get homeEmptyDocsSubtitle => 'Importez votre premier document!';

  @override
  String get homeUploadFirst => 'Importer un document';

  @override
  String get homeShareLabel => 'Partagez VeriScript avec votre classe';

  @override
  String get homeShareButton => 'Partager sur WhatsApp';

  @override
  String get homeShareText =>
      'Découvrez VeriScript — détection de plagiat + conversion de fichiers pour les étudiants au Cameroun! Télécharger: https://play.google.com/store/apps/details?id=com.veriscipt.mobile';

  @override
  String get homeMonthlyUsage => 'Utilisation mensuelle';

  @override
  String get homeFreePlan => 'Plan gratuit';

  @override
  String get homeUpgradeNudge => 'Mettre à niveau — accès illimité';

  @override
  String homeBonusScans(int count) {
    return '$count scans bonus disponibles';
  }

  @override
  String get converterTitle => 'Convertisseur de fichiers';

  @override
  String get converterSelectFile => 'Appuyez pour sélectionner un fichier';

  @override
  String get converterFileTypes => 'PDF, DOCX, TXT · Max 10 Mo';

  @override
  String get converterLargeFile =>
      'Fichier volumineux — cela peut consommer beaucoup de données mobiles';

  @override
  String get converterConvertTo => 'Convertir en:';

  @override
  String get converterChooseDifferent => 'Choisir un autre fichier';

  @override
  String get converterButton => 'Convertir maintenant';

  @override
  String converterFreeRemaining(int used, int max) {
    return '$used sur $max conversions gratuites restantes ce mois-ci';
  }

  @override
  String get converterUploading => 'Téléchargement de votre fichier...';

  @override
  String get converterConverting => 'Conversion de votre document...';

  @override
  String get converterDone => 'Conversion terminée!';

  @override
  String get converterDownload => 'Télécharger le fichier';

  @override
  String get converterAnother => 'Convertir un autre';

  @override
  String get scannerTitle => 'Vérification de plagiat';

  @override
  String get scannerSelectFile => 'Appuyez pour sélectionner un document';

  @override
  String get scannerMimeTypes => 'PDF, DOCX, TXT · Max 20 Mo';

  @override
  String get scannerDataWarning =>
      'Fichier volumineux — cela peut consommer beaucoup de données mobiles';

  @override
  String get scannerScanButton => 'Lancer l\'analyse';

  @override
  String get scannerScanning => 'Analyse de votre document...';

  @override
  String get scannerDone => 'Analyse terminée!';

  @override
  String get scannerQuotaExceeded => 'Limite mensuelle d\'analyses atteinte';

  @override
  String get scannerQuotaUpgrade => 'Passez à Pro pour des analyses illimitées';

  @override
  String get scanResultTitle => 'Rapport d\'analyse';

  @override
  String get scanResultSimilarity => 'Similarité';

  @override
  String get scanResultOriginal => 'Original';

  @override
  String get scanResultSources => 'Sources correspondantes';

  @override
  String get scanResultNoSources => 'Aucune source correspondante trouvée';

  @override
  String get scanResultExportPdf => 'Exporter PDF';

  @override
  String get scanResultShare => 'Partager';

  @override
  String get scanResultLow => 'Faible similarité — le contenu semble original';

  @override
  String get scanResultMedium => 'Similarité modérée — vérifiez les sources';

  @override
  String get scanResultHigh => 'Similarité élevée — plagiat potentiel détecté';

  @override
  String get ocrTitle => 'Numériseur OCR';

  @override
  String get ocrSelectSource => 'Choisir la source d\'image';

  @override
  String get ocrCamera => 'Prendre une photo';

  @override
  String get ocrGallery => 'Choisir dans la galerie';

  @override
  String get ocrProcessing => 'Extraction du texte...';

  @override
  String get ocrNoText => 'Aucun texte trouvé dans l\'image';

  @override
  String get ocrCopy => 'Copier le texte';

  @override
  String get ocrScanForPlagiarism => 'Analyser le plagiat';

  @override
  String get ocrTranslate => 'Traduire';

  @override
  String get ocrScanAgain => 'Numériser un autre';

  @override
  String get ocrEditText => 'Modifier le texte';

  @override
  String get translatorTitle => 'Traducteur';

  @override
  String get translatorInputHint => 'Entrez le texte à traduire...';

  @override
  String get translatorSwap => 'Inverser les langues';

  @override
  String get translatorAuto => 'Détecter la langue';

  @override
  String get translatorFrom => 'De';

  @override
  String get translatorTo => 'Vers';

  @override
  String get translatorCopy => 'Copier la traduction';

  @override
  String translatorCharsUsed(int used, int limit) {
    return '$used / $limit caractères utilisés ce mois-ci';
  }

  @override
  String get translatorQuotaExceeded =>
      'Limite mensuelle de traduction atteinte';

  @override
  String get translatorSelectLanguage => 'Sélectionner une langue';

  @override
  String get translatorSearch => 'Rechercher des langues...';

  @override
  String get translatorPrioritySection => 'Suggérées';

  @override
  String get translatorAllSection => 'Toutes les langues';

  @override
  String get historyTitle => 'Historique';

  @override
  String get historySearch => 'Rechercher des documents...';

  @override
  String get historyEmpty => 'Aucun historique';

  @override
  String get historyEmptySubtitle =>
      'Vos documents analysés et convertis apparaîtront ici';

  @override
  String get historyFilterAll => 'Tout';

  @override
  String get historyFilterScans => 'Analyses';

  @override
  String get historyFilterConversions => 'Conversions';

  @override
  String get historyFilterTranslations => 'Traductions';

  @override
  String get historyFilterOcr => 'OCR';

  @override
  String get historySort => 'Trier';

  @override
  String get historySortNewest => 'Plus récent';

  @override
  String get historySortOldest => 'Plus ancien';

  @override
  String get historyStatusDone => 'Terminé';

  @override
  String get historyStatusFailed => 'Échoué';

  @override
  String get historyStatusPending => 'En attente';

  @override
  String get historyDeleteConfirm => 'Supprimer ce document?';

  @override
  String get historyDeleteBody =>
      'Cela supprimera le fichier et toutes les données associées. Cette action est irréversible.';

  @override
  String get historyCancel => 'Annuler';

  @override
  String get historyDelete => 'Supprimer';

  @override
  String get historyDeletedMessage => 'Document supprimé';

  @override
  String get historyUndo => 'Annuler';

  @override
  String get driveTitle => 'Google Drive';

  @override
  String get driveConnectDesc =>
      'Importez et exportez des documents depuis votre Google Drive';

  @override
  String get driveConnect => 'Connecter avec Google';

  @override
  String get driveSignOut => 'Déconnecter';

  @override
  String get driveImport => 'Importer';

  @override
  String get driveEmpty => 'Aucun document trouvé';

  @override
  String get driveEmptySubtitle =>
      'Les fichiers PDF, DOCX et TXT de votre Drive apparaîtront ici';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Language / Langue';

  @override
  String get settingsGoogleDrive => 'Google Drive';

  @override
  String get settingsGoogleDriveDesc => 'Importer et exporter des documents';

  @override
  String get settingsReferralTitle => 'Parrainer un ami';

  @override
  String get settingsReferralDesc =>
      'Partagez votre code et obtenez tous les deux 2 scans bonus!';

  @override
  String get settingsReferralCode => 'Votre code de parrainage';

  @override
  String get settingsCopyCode => 'Copier le code';

  @override
  String get settingsCodeCopied => 'Code copié!';

  @override
  String get settingsReferralShare => 'Partager sur WhatsApp';

  @override
  String settingsReferralFriends(int count) {
    return '$count ami(s) inscrit(s)';
  }

  @override
  String settingsBonusScans(int count) {
    return '+$count scans bonus';
  }

  @override
  String get notifScanCompleteTitle => 'Analyse terminée';

  @override
  String get notifScanCompleteBody => 'Votre rapport de plagiat est prêt';

  @override
  String get notifConversionCompleteTitle => 'Conversion terminée';

  @override
  String get notifConversionCompleteBody =>
      'Votre fichier est prêt à télécharger';

  @override
  String get notifTranslationCompleteTitle => 'Traduction terminée';

  @override
  String get notifSyncCompleteTitle => 'Synchronisation terminée';

  @override
  String notifSyncCompleteBody(int count) {
    return '$count éléments synchronisés';
  }

  @override
  String get errorNetworkTitle => 'Pas de connexion';

  @override
  String get errorNetworkBody => 'Vérifiez votre internet et réessayez.';

  @override
  String get errorGenericTitle => 'Quelque chose s\'est mal passé';

  @override
  String get errorRetry => 'Réessayer';

  @override
  String get offlineBanner =>
      'Vous êtes hors ligne — affichage des données en cache';

  @override
  String get stubComingSoon => 'Disponible en Phase 2';

  @override
  String get authErrorInvalidCredentials => 'Email ou mot de passe invalide';

  @override
  String get authErrorEmailInUse => 'Un compte existe déjà avec cet email';

  @override
  String get authErrorWeakPassword =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get authErrorNetwork => 'Pas de connexion. Vérifiez votre internet.';

  @override
  String get authErrorUnknown =>
      'Quelque chose s\'est mal passé. Veuillez réessayer.';
}
