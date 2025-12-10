import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/game_menu_screen.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('GameMenuScreen displays three buttons and balance', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(),
        child: const MaterialApp(home: GameMenuScreen()),
      ),
    );

    expect(find.text('Balance: \$10.00'), findsOneWidget);
    expect(find.text('Buy Ingredients'), findsOneWidget);
    expect(find.text('Prepare Lemonade'), findsOneWidget);
    expect(find.text('Set Prices'), findsOneWidget);
    expect(find.text('Start Day'), findsOneWidget);
  });
}
