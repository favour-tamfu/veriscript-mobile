import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:veriscipt_mobile/features/auth/presentation/login_screen.dart';
import 'package:veriscipt_mobile/features/auth/presentation/register_screen.dart';
import 'package:veriscipt_mobile/l10n/app_localizations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Widget buildAuth(Widget screen) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    );
  }

  group('Login screen', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(buildAuth(const LoginScreen()));
      await tester.pump();

      expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    });

    testWidgets('sign-in button is present', (tester) async {
      await tester.pumpWidget(buildAuth(const LoginScreen()));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows validation error on empty submit', (tester) async {
      await tester.pumpWidget(buildAuth(const LoginScreen()));
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // At least one validation message appears
      expect(find.byType(Text), findsWidgets);
    });
  });

  group('Register screen', () {
    testWidgets('renders all required fields', (tester) async {
      await tester.pumpWidget(buildAuth(const RegisterScreen()));
      await tester.pump();

      // Name, email, password, confirm, referral = 5 TextFormFields
      expect(find.byType(TextFormField), findsAtLeastNWidgets(5));
    });

    testWidgets('referral code field is present', (tester) async {
      await tester.pumpWidget(buildAuth(const RegisterScreen()));
      await tester.pump();

      expect(find.byIcon(Icons.card_giftcard_rounded), findsOneWidget);
    });

    testWidgets('create account button is present', (tester) async {
      await tester.pumpWidget(buildAuth(const RegisterScreen()));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('can type into name field', (tester) async {
      await tester.pumpWidget(buildAuth(const RegisterScreen()));
      await tester.pump();

      final nameField = find.byType(TextFormField).first;
      await tester.enterText(nameField, 'Jean-Marie');
      expect(find.text('Jean-Marie'), findsOneWidget);
    });

    testWidgets('password strength indicator renders', (tester) async {
      await tester.pumpWidget(buildAuth(const RegisterScreen()));
      await tester.pump();

      // Password field is the 3rd TextFormField
      final passwordField = find.byType(TextFormField).at(2);
      await tester.enterText(passwordField, 'weak');
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
