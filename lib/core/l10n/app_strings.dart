import 'package:flutter/widgets.dart';

class AppStrings {
  const AppStrings._(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('fr')];

  static AppStrings of(BuildContext context) {
    return AppStrings._(Localizations.localeOf(context));
  }

  bool get _isFrench => locale.languageCode == 'fr';

  String get onboardingTitle => _isFrench
      ? 'Des outils documentaires adaptes aux usages reels des etudiants'
      : 'Document tools built for real campus workflows';

  String get onboardingBody => _isFrench
      ? "Verifiez l'originalite, numerisez des pages, convertissez des fichiers et gardez vos documents importants hors ligne sans gaspiller vos donnees mobiles."
      : 'Check originality, scan pages, convert files, and keep key documents offline without wasting mobile data.';

  String get getStarted => _isFrench ? 'Commencer' : 'Get started';

  String get authTitle =>
      _isFrench ? 'Connectez-vous pour continuer' : 'Sign in to continue';

  String get authBody => _isFrench
      ? 'Utilisez votre e-mail pour acceder a vos analyses, conversions et documents synchronises.'
      : 'Use your email to access your scans, conversions, and synced document history.';

  String get signIn => _isFrench ? 'Se connecter' : 'Sign in';

  String get createAccount => _isFrench ? 'Creer un compte' : 'Create account';

  String get authHint => _isFrench
      ? "L'authentification Supabase et la reinitialisation du mot de passe peuvent etre branchees ici ensuite."
      : 'Supabase authentication and password reset can plug into this screen next.';

  String get homeGreeting =>
      _isFrench ? 'Heureux de vous revoir' : 'Welcome back';

  String get homeSubtitle => _isFrench
      ? "Vos outils d'integrite et de productivite sont prets."
      : 'Your integrity and productivity tools are ready.';
}
