// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get onboardingTitle =>
      'Des outils documentaires adaptes aux usages reels des etudiants';

  @override
  String get onboardingBody =>
      'Verifiez l\'originalite, numerisez des pages, convertissez des fichiers et gardez vos documents importants hors ligne sans gaspiller vos donnees mobiles.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get authTitle => 'Connectez-vous pour continuer';

  @override
  String get authCreateTitle => 'Creez votre compte VeriScript';

  @override
  String get authBody =>
      'Utilisez votre e-mail pour acceder a vos analyses, conversions et documents synchronises.';

  @override
  String get authCreateBody =>
      'Commencez avec une connexion par e-mail et synchronisez vos outils documentaires sur plusieurs appareils.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signOut => 'Se deconnecter';

  @override
  String get createAccount => 'Creer un compte';

  @override
  String get switchToSignIn => 'Vous avez deja un compte ? Connectez-vous';

  @override
  String get resetPassword => 'Reinitialiser le mot de passe';

  @override
  String get authEmailError => 'Entrez une adresse e-mail valide.';

  @override
  String get authPasswordError => 'Utilisez au moins 6 caracteres.';

  @override
  String get authResetNeedsEmail =>
      'Entrez d\'abord votre e-mail pour demander une reinitialisation.';

  @override
  String get authResetSent =>
      'Si le compte existe, un lien de reinitialisation a ete envoye.';

  @override
  String get authHint =>
      'L\'authentification Supabase et la reinitialisation du mot de passe peuvent etre branchees ici ensuite.';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get homeGreeting => 'Heureux de vous revoir';

  @override
  String get homeSubtitle =>
      'Vos outils d\'integrite et de productivite sont prets.';

  @override
  String homeSubtitleWithEmail(Object email) {
    return 'Connecte en tant que $email. Vos outils d\'integrite et de productivite sont prets.';
  }

  @override
  String get featurePlagiarism => 'Plagiat';

  @override
  String get featureOcr => 'OCR';

  @override
  String get featureTranslate => 'Traduction';

  @override
  String get featureOffline => 'Hors ligne';

  @override
  String get openConverter => 'Conversion';

  @override
  String get openLibrary => 'Bibliotheque';

  @override
  String get openPlans => 'Tarifs';

  @override
  String get toolPlagiarismTitle => 'Verification du plagiat';

  @override
  String get toolPlagiarismBody => 'Comparez vos brouillons avant soumission.';

  @override
  String get toolConversionTitle => 'Conversion de fichiers';

  @override
  String get toolConversionBody =>
      'Convertissez PDF, DOCX et TXT avec un retour adapte aux faibles debits.';

  @override
  String get toolTranslationTitle => 'Traduction';

  @override
  String get toolTranslationBody =>
      'Flux de travail anglais et francais avec plus de 100 langues cibles.';

  @override
  String get toolOfflineTitle => 'Coffre hors ligne';

  @override
  String get toolOfflineBody =>
      'Gardez vos documents recents accessibles sans connexion.';

  @override
  String get recentDocuments => 'Documents recents';

  @override
  String get converterTitle => 'Convertisseur de fichiers';

  @override
  String get converterBody =>
      'Mettez des fichiers en file de conversion et conservez l\'historique hors ligne.';

  @override
  String get converterSetupNotice =>
      'Definissez CONVERTER_ENDPOINT dans .env.local pour envoyer les fichiers a votre backend de conversion.';

  @override
  String get converterTargetFormat => 'Format cible';

  @override
  String get converterPickFile => 'Choisir un fichier a convertir';

  @override
  String get libraryTitle => 'Bibliotheque documentaire hors ligne';

  @override
  String get libraryBody =>
      'Les conversions enregistrees et les metadonnees de synchronisation restent disponibles meme avec un reseau faible.';

  @override
  String get libraryEmpty => 'Aucun document n\'a encore ete enregistre.';

  @override
  String get paywallTitle => 'VeriScript Plus';

  @override
  String get paywallBody =>
      'Debloquez des limites plus elevees pour la conversion, l\'OCR, la traduction et l\'acces hors ligne.';

  @override
  String get paywallNoPackages =>
      'Aucun forfait actif n\'est disponible pour le moment. Ajoutez des offres dans RevenueCat pour activer les achats.';

  @override
  String get paywallUnlock => 'Debloquer Plus';

  @override
  String get paywallRestore => 'Restaurer les achats';
}
