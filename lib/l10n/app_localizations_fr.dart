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
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Language / Langue';

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
