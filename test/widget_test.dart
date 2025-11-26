import 'package:flutter_test/flutter_test.dart';

import 'package:lemonade_tycoon/main.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LemonadeTycoonApp());

    // Verify that our title is present.
    expect(find.text('Lemonade Tycoon'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
  });
}
