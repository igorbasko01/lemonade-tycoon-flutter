import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/game_menu_screen.dart';
import 'package:lemonade_tycoon/welcome_screen.dart';

void main() {
  testWidgets('GameMenuScreen displays three buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameMenuScreen()));

    expect(find.text('Buy Ingredients'), findsOneWidget);
    expect(find.text('Prepare Lemonade'), findsOneWidget);
    expect(find.text('Sell Lemonade'), findsOneWidget);
  });

  testWidgets('WelcomeScreen navigates to GameMenuScreen on tap', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    final startButton = find.text('Start Game');
    expect(startButton, findsOneWidget);

    await tester.tap(startButton);
    await tester.pumpAndSettle();

    expect(find.byType(GameMenuScreen), findsOneWidget);
    expect(find.text('Buy Ingredients'), findsOneWidget);
  });
}
