import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veriscipt_mobile/features/auth/domain/auth_failure.dart';

void main() {
  const en = Locale('en');
  const fr = Locale('fr');

  group('InvalidCredentials', () {
    const failure = InvalidCredentials();

    test('returns English message', () {
      expect(failure.message(en), 'Invalid email or password');
    });

    test('returns French message', () {
      expect(failure.message(fr), 'Email ou mot de passe invalide');
    });
  });

  group('EmailAlreadyInUse', () {
    const failure = EmailAlreadyInUse();

    test('returns English message', () {
      expect(failure.message(en), 'An account already exists with this email');
    });

    test('returns French message', () {
      expect(failure.message(fr), 'Un compte existe déjà avec cet email');
    });
  });

  group('WeakPassword', () {
    const failure = WeakPassword();

    test('returns English message', () {
      expect(failure.message(en), 'Password must be at least 8 characters');
    });

    test('returns French message', () {
      expect(
        failure.message(fr),
        'Le mot de passe doit comporter au moins 8 caractères',
      );
    });
  });

  group('NetworkError', () {
    const failure = NetworkError();

    test('returns English message', () {
      expect(failure.message(en), 'No connection. Check your internet.');
    });

    test('returns French message', () {
      expect(
        failure.message(fr),
        'Pas de connexion. Vérifiez votre internet.',
      );
    });
  });

  group('Unknown', () {
    test('returns default English fallback', () {
      const failure = Unknown();
      expect(failure.message(en), 'Something went wrong. Please try again.');
    });

    test('returns overrideEn when provided', () {
      const failure = Unknown(overrideEn: 'Custom error');
      expect(failure.message(en), 'Custom error');
    });

    test('returns default French fallback', () {
      const failure = Unknown();
      expect(failure.message(fr), contains('Veuillez réessayer'));
    });

    test('returns overrideFr when provided', () {
      const failure = Unknown(overrideFr: 'Erreur personnalisée');
      expect(failure.message(fr), 'Erreur personnalisée');
    });
  });

  group('AuthFailure is sealed', () {
    test('all subtypes implement message()', () {
      final failures = <AuthFailure>[
        const InvalidCredentials(),
        const EmailAlreadyInUse(),
        const WeakPassword(),
        const NetworkError(),
        const Unknown(),
      ];
      for (final f in failures) {
        expect(f.message(en), isNotEmpty);
        expect(f.message(fr), isNotEmpty);
      }
    });
  });
}
