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
  String get authBody =>
      'Utilisez votre e-mail pour acceder a vos analyses, conversions et documents synchronises.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get createAccount => 'Creer un compte';

  @override
  String get authHint =>
      'L\'authentification Supabase et la reinitialisation du mot de passe peuvent etre branchees ici ensuite.';

  @override
  String get homeGreeting => 'Heureux de vous revoir';

  @override
  String get homeSubtitle =>
      'Vos outils d\'integrite et de productivite sont prets.';
}
