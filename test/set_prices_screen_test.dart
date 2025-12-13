import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/recipes.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/screens/set_prices_screen.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('SetPricesScreen displays all products', (
    WidgetTester tester,
  ) async {
    final player = Player(name: 'Test Player', wallet: Wallet(10.0));
    player.addShop(
      Shop(
        inventory: Inventory(ingredients: {}),
        wallet: Wallet(0.0),
        prices: {},
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(player: player),
        child: const MaterialApp(home: SetPricesScreen()),
      ),
    );

    expect(find.text('Sweet Lemonade'), findsOneWidget);
    expect(find.text('Mild Lemonade'), findsOneWidget);
    expect(find.text('Refreshing Lemonade'), findsOneWidget);
  });

  testWidgets('Updating price updates state', (WidgetTester tester) async {
    final player = Player(name: 'Test Player', wallet: Wallet(10.0));
    player.addShop(
      Shop(
        inventory: Inventory(ingredients: {}),
        wallet: Wallet(0.0),
        prices: {Recipes.sweetLemonade.outputIngredient: 1.0},
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(player: player),
        child: const MaterialApp(home: SetPricesScreen()),
      ),
    );

    // Initial price
    expect(find.text('\$1.00'), findsOneWidget);

    // Tap increase
    await tester.tap(find.widgetWithIcon(IconButton, Icons.add).first);
    await tester.pump();

    // Price should be 1.10
    expect(find.text('\$1.10'), findsOneWidget);

    // Verify view model state
    final shop = player.shops.first;
    expect(
      shop.prices[Recipes.sweetLemonade.outputIngredient],
      closeTo(1.10, 0.001),
    );
  });
}
