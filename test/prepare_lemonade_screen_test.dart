import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/ingredients.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/prepare_lemonade_screen.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('PrepareLemonadeScreen displays recipes and prepare button', (WidgetTester tester) async {
    // Player with some ingredients
    final player = Player(name: 'Maker', wallet: Wallet(10.0));
    player.addShop(Shop(
      inventory: Inventory(ingredients: {
        Ingredients.lemon: 5,
        Ingredients.sugar: 5,
        Ingredients.water: 5,
        Ingredients.ice: 5, 
      }),
      wallet: Wallet(0.0),
      prices: {},
    ));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(player: player),
        child: const MaterialApp(home: PrepareLemonadeScreen()),
      ),
    );

    // Initial check
    expect(find.text('Sweet Lemonade'), findsOneWidget);
    expect(find.text('In Stock: 0'), findsNWidgets(3)); // All start at 0
    expect(find.text('Mild Lemonade'), findsOneWidget);
    expect(find.text('Refreshing Lemonade'), findsOneWidget);
    
    // Check ingredient status display for Sweet Lemonade
    final sweetCard = find.widgetWithText(Card, 'Sweet Lemonade');
    expect(
      find.descendant(
        of: sweetCard, 
        matching: find.textContaining('LEMON: 1 (Owned: 5)')
      ), 
      findsOneWidget
    );
    
    // Prepare button should be enabled for Sweet Lemonade
    final prepareButton = find.descendant(
      of: sweetCard,
      matching: find.widgetWithText(ElevatedButton, 'Prepare')
    );
    expect(prepareButton, findsOneWidget);
    
    // Tap prepare button for Sweet Lemonade
    await tester.tap(prepareButton);
    await tester.pump();
    
    // Inventory should decrease
    // Sweet Lemonade uses 1 lemon, 4 sugar, 1 water.
    // Original: 5, 5, 5, 5
    // New: 4, 1, 4, 5
    
    // Verify UI reflects lower inventory
    // Now Owned Sugar should be 1.
    expect(
      find.descendant(
        of: sweetCard,
        matching: find.textContaining('SUGAR: 4 (Owned: 1)')
      ),
      findsOneWidget
    );

    // Verify Stock updated to 1
    expect(
      find.descendant(
        of: sweetCard,
        matching: find.text('In Stock: 1')
      ),
      findsOneWidget
    );
  });

  testWidgets('Prepare button disabled if ingredients missing', (WidgetTester tester) async {
    // Player with NO ingredients
    final player = Player(name: 'Empty', wallet: Wallet(10.0));
    player.addShop(Shop(
      inventory: Inventory(ingredients: {}),
      wallet: Wallet(0.0),
      prices: {},
    ));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(player: player),
        child: const MaterialApp(home: PrepareLemonadeScreen()),
      ),
    );

    // Prepare buttons should be disabled
    final prepareButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Prepare').first);
    expect(prepareButton.onPressed, isNull);
  });
}
