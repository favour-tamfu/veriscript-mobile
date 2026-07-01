import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veriscipt_mobile/core/providers/connectivity_provider.dart';
import 'package:veriscipt_mobile/core/widgets/vs_offline_banner.dart';
import 'package:veriscipt_mobile/l10n/app_localizations.dart';

Widget _buildApp({required bool isOffline}) {
  return ProviderScope(
    overrides: [
      isOfflineProvider.overrideWithValue(isOffline),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: VsOfflineBanner()),
    ),
  );
}

void main() {
  group('VsOfflineBanner', () {
    testWidgets('shows banner with wifi_off icon when offline', (tester) async {
      await tester.pumpWidget(_buildApp(isOffline: true));
      await tester.pump();

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('shows offline text when offline', (tester) async {
      await tester.pumpWidget(_buildApp(isOffline: true));
      await tester.pump();

      expect(find.textContaining('offline'), findsOneWidget);
    });

    testWidgets('banner is collapsed (height 0) when online', (tester) async {
      await tester.pumpWidget(_buildApp(isOffline: false));
      await tester.pump();

      // When online the height constraint is 0
      final box = tester.renderObject<RenderBox>(find.byType(AnimatedContainer));
      expect(box.size.height, 0.0);
    });
  });
}
