import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/game_manager.dart';
import 'package:lemonade_tycoon/screens/buy_ingredients_screen.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('BuyIngredientsScreen displays balance and items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(gameManager: GameManager()),
        child: const MaterialApp(home: BuyIngredientsScreen()),
      ),
    );

    // Initial balance is 10.00
    expect(find.text('Wallet: \$10.00'), findsOneWidget);

    // Finds generic indicators of content
    expect(find.text('LEMON'), findsOneWidget);
    expect(find.text('SUGAR'), findsOneWidget);

    // Finds Buy buttons
    expect(
      find.text('Buy 1'),
      findsNWidgets(4),
    ); // 4 ingredients in default supplier
  });

  testWidgets('Buy button updates balance and owned amount', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(gameManager: GameManager()),
        child: const MaterialApp(home: BuyIngredientsScreen()),
      ),
    );

    // Find Lemon item info
    // Default: Price 0.50, Owned 0
    expect(find.text('Price: \$0.50 | Owned: 0'), findsOneWidget);

    // Tap Buy for Lemon (first item usually, but let's be careful with order)
    // The list iterates defaults: Lemon, Sugar, Ice, Water
    await tester.tap(find.text('Buy 1').first);
    await tester.pump();

    // Balance decreased by 0.50
    expect(find.text('Wallet: \$9.50'), findsOneWidget);

    // Owned increased to 1
    expect(find.text('Price: \$0.50 | Owned: 1'), findsOneWidget);
  });

  testWidgets('Buy button is disabled when insufficient funds', (
    WidgetTester tester,
  ) async {
    // Create a player with very low balance
    final player = Player(name: 'Poor', wallet: Wallet(0.01));
    // We need to initialize the player's shop manually as GameViewModel does internally
    player.addShop(
      Shop(
        inventory: Inventory(ingredients: {}),
        wallet: Wallet(0.0),
        prices: {},
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(gameManager: GameManager(player: player)),
        child: const MaterialApp(home: BuyIngredientsScreen()),
      ),
    );

    // Verify button is disabled
    final buyButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Buy 1').first,
    );
    expect(buyButton.onPressed, isNull);
  });
}
