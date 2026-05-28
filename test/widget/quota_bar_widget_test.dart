import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:veriscipt_mobile/features/home/data/quota_repository.dart';
import 'package:veriscipt_mobile/features/home/presentation/quota_bar_widget.dart';

Widget _buildWidget({
  required AsyncValue<UsageQuota> quotaAsync,
  bool isFrench = false,
}) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: QuotaBarWidget(
          quotaAsync: quotaAsync,
          isFrench: isFrench,
          onUpgrade: () {},
        ),
      ),
    ),
  );
}


void main() {
  group('QuotaBarWidget', () {
    testWidgets('renders four LinearPercentIndicator bars', (tester) async {
      await tester.pumpWidget(_buildWidget(
        quotaAsync: AsyncData(UsageQuota(
          scansUsed: 1,
          conversionsUsed: 2,
          ocrUsed: 3,
          charsTranslated: 500,
          periodStart: DateTime(2026, 1, 1),
        )),
      ));
      expect(find.byType(LinearPercentIndicator), findsNWidgets(4));
    });

    testWidgets('shows upgrade nudge when scans at limit', (tester) async {
      await tester.pumpWidget(_buildWidget(
        quotaAsync: AsyncData(UsageQuota(
          scansUsed: 3, // at limit (3/3)
          conversionsUsed: 0,
          ocrUsed: 0,
          charsTranslated: 0,
          periodStart: DateTime(2026, 1, 1),
        )),
      ));
      expect(find.textContaining('Upgrade'), findsOneWidget);
    });

    testWidgets('does not show upgrade nudge when under limits', (tester) async {
      await tester.pumpWidget(_buildWidget(
        quotaAsync: AsyncData(UsageQuota(
          scansUsed: 1,
          conversionsUsed: 1,
          ocrUsed: 2,
          charsTranslated: 100,
          periodStart: DateTime(2026, 1, 1),
        )),
      ));
      expect(find.textContaining('Upgrade'), findsNothing);
    });

    testWidgets('shows bonus scans badge when bonus_scans > 0', (tester) async {
      await tester.pumpWidget(_buildWidget(
        quotaAsync: AsyncData(UsageQuota(
          scansUsed: 0,
          conversionsUsed: 0,
          ocrUsed: 0,
          charsTranslated: 0,
          periodStart: DateTime(2026, 1, 1),
          bonusScans: 4,
        )),
      ));
      expect(find.textContaining('bonus scans'), findsOneWidget);
    });

    testWidgets('does not show bonus scans badge when bonus_scans is 0', (tester) async {
      await tester.pumpWidget(_buildWidget(
        quotaAsync: AsyncData(UsageQuota(
          scansUsed: 0,
          conversionsUsed: 0,
          ocrUsed: 0,
          charsTranslated: 0,
          periodStart: DateTime(2026, 1, 1),
        )),
      ));
      expect(find.textContaining('bonus scans'), findsNothing);
    });

    testWidgets('shows shimmer placeholder while loading', (tester) async {
      await tester.pumpWidget(_buildWidget(quotaAsync: const AsyncLoading()));
      // Shimmer wraps a SizedBox; verify no LinearPercentIndicator
      expect(find.byType(LinearPercentIndicator), findsNothing);
    });

    testWidgets('renders nothing on error', (tester) async {
      await tester.pumpWidget(_buildWidget(
        quotaAsync: AsyncError(Exception('fail'), StackTrace.empty),
      ));
      expect(find.byType(LinearPercentIndicator), findsNothing);
    });

    testWidgets('shows French labels when isFrench=true', (tester) async {
      await tester.pumpWidget(_buildWidget(
        quotaAsync: AsyncData(UsageQuota(
          scansUsed: 1,
          conversionsUsed: 1,
          ocrUsed: 1,
          charsTranslated: 100,
          periodStart: DateTime(2026, 1, 1),
        )),
        isFrench: true,
      ));
      expect(find.textContaining('Utilisation mensuelle'), findsOneWidget);
      expect(find.textContaining('Plan gratuit'), findsOneWidget);
    });
  });
}
