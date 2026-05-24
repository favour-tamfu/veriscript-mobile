import 'package:flutter/material.dart';

sealed class AuthFailure implements Exception {
  const AuthFailure();

  String message(Locale locale);
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials();

  @override
  String message(Locale locale) {
    return locale.languageCode == 'fr'
        ? 'Email ou mot de passe invalide'
        : 'Invalid email or password';
  }
}

class EmailAlreadyInUse extends AuthFailure {
  const EmailAlreadyInUse();

  @override
  String message(Locale locale) {
    return locale.languageCode == 'fr'
        ? 'Un compte existe déjà avec cet email'
        : 'An account already exists with this email';
  }
}

class WeakPassword extends AuthFailure {
  const WeakPassword();

  @override
  String message(Locale locale) {
    return locale.languageCode == 'fr'
        ? 'Le mot de passe doit comporter au moins 8 caractères'
        : 'Password must be at least 8 characters';
  }
}

class NetworkError extends AuthFailure {
  const NetworkError();

  @override
  String message(Locale locale) {
    return locale.languageCode == 'fr'
        ? 'Pas de connexion. Vérifiez votre internet.'
        : 'No connection. Check your internet.';
  }
}

class Unknown extends AuthFailure {
  const Unknown();

  @override
  String message(Locale locale) {
    return locale.languageCode == 'fr'
        ? 'Quelque chose s\'est mal passé. Veuillez réessayer.'
        : 'Something went wrong. Please try again.';
  }
}
