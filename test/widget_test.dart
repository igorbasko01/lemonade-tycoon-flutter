import 'package:flutter_test/flutter_test.dart';

import 'package:lemonade_tycoon/main.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LemonadeTycoonApp());

    // Verify that our title is present.
    // Verify that the Game Menu Screen is shown
    expect(find.text('Day 1 - Morning'), findsOneWidget);
    expect(find.text('Start Day'), findsOneWidget);
  });
}
