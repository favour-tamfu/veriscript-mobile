import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veriscipt_mobile/features/splash/presentation/splash_screen.dart';

void main() {
  testWidgets('renders splash branding', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SplashScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('VeriScript'), findsOneWidget);
  });
}
