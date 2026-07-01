import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veriscipt_mobile/core/widgets/vs_button.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('VsButton.primary', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(_wrap(
        VsButton.primary(label: 'Submit', onPressed: () {}),
      ));
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        VsButton.primary(label: 'Go', onPressed: () => tapped = true),
      ));
      await tester.tap(find.text('Go'));
      expect(tapped, isTrue);
    });

    testWidgets('shows loading spinner when isLoading=true', (tester) async {
      await tester.pumpWidget(_wrap(
        VsButton.primary(label: 'Go', onPressed: () {}, isLoading: true),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Go'), findsNothing);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(_wrap(
        VsButton.primary(label: 'Disabled', onPressed: null),
      ));
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('renders icon alongside label when icon provided', (tester) async {
      await tester.pumpWidget(_wrap(
        VsButton.primary(
          label: 'Upload',
          onPressed: () {},
          icon: Icons.upload_rounded,
        ),
      ));
      expect(find.byIcon(Icons.upload_rounded), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
    });
  });

  group('VsButton.secondary', () {
    testWidgets('renders as OutlinedButton', (tester) async {
      await tester.pumpWidget(_wrap(
        VsButton.secondary(label: 'Cancel', onPressed: () {}),
      ));
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('shows spinner when isLoading=true', (tester) async {
      await tester.pumpWidget(_wrap(
        VsButton.secondary(label: 'Cancel', onPressed: () {}, isLoading: true),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('VsButton.text', () {
    testWidgets('renders as TextButton', (tester) async {
      await tester.pumpWidget(_wrap(
        VsButton.text(label: 'Skip', onPressed: () {}),
      ));
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var count = 0;
      await tester.pumpWidget(_wrap(
        VsButton.text(label: 'Skip', onPressed: () => count++),
      ));
      await tester.tap(find.text('Skip'));
      expect(count, 1);
    });
  });
}
