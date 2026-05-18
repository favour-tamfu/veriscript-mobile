import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veriscript_mobile/app.dart';

void main() {
  testWidgets('renders VeriScript shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: VeriScriptApp()));
    await tester.pump();

    expect(find.text('VeriScript'), findsOneWidget);
  });
}
