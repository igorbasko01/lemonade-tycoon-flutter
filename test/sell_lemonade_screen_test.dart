import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/recipes.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/sell_lemonade_screen.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('SellLemonadeScreen displays products, prices, and customers', (WidgetTester tester) async {
    final player = Player(name: 'Seller', wallet: Wallet(10.0));
    final shop = Shop(
      inventory: Inventory(ingredients: {
        Recipes.sweetLemonade.outputIngredient: 5,
        Recipes.mildLemonade.outputIngredient: 0,
        Recipes.refreshingLemonade.outputIngredient: 2,
      }),
      wallet: Wallet(0.0),
      prices: {
        Recipes.sweetLemonade.outputIngredient: 1.50,
      },
    );
    player.addShop(shop);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(player: player), // Customers generated automatically
        child: const MaterialApp(home: SellLemonadeScreen()),
      ),
    );

    // Check Wallet
    expect(find.text('Wallet: \$10.00'), findsOneWidget);

    // Check Pricing Section
    expect(find.text('Sweet Lemonade Pitcher'), findsOneWidget);
    // Price defaults to 1.50 as set
    expect(find.textContaining('Price: \$1.50'), findsOneWidget);
    expect(find.textContaining('Stock: 5'), findsOneWidget);

    // Refreshing Lemonade (price unset/default, stock 2)
    final refreshingTile = find.ancestor(of: find.text('Refreshing Lemonade Pitcher'), matching: find.byType(Card));
    expect(
        find.descendant(of: refreshingTile, matching: find.textContaining('Price: \$1.00')),
        findsOneWidget);
    expect(
        find.descendant(of: refreshingTile, matching: find.textContaining('Stock: 2')), 
        findsOneWidget);

    // Check Customers Section
    expect(find.text('Customers'), findsOneWidget);
    // We expect 3 customers
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Charlie'), findsOneWidget);
  });

  testWidgets('Updating price updates UI', (WidgetTester tester) async {
    final player = Player(name: 'Seller', wallet: Wallet(10.0));
    final shop = Shop(
      inventory: Inventory(ingredients: {
        Recipes.sweetLemonade.outputIngredient: 5,
      }),
      wallet: Wallet(0.0),
      prices: {
         Recipes.sweetLemonade.outputIngredient: 1.00,
      },
    );
    player.addShop(shop);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(player: player),
        child: const MaterialApp(home: SellLemonadeScreen()),
      ),
    );

    // Find Sweet Lemonade Pitcher tile
    final tile = find.ancestor(
      of: find.text('Sweet Lemonade Pitcher'),
      matching: find.byType(Card)
    );
    
    // Find Add/Remove buttons inside that tile (Icon(Icons.add))
    final addButton = find.descendant(of: tile, matching: find.byIcon(Icons.add));
    
    await tester.tap(addButton);
    await tester.pump();
    
    // Price should increase to 1.10
    expect(find.textContaining('Price: \$1.10'), findsOneWidget);
    
    final removeButton = find.descendant(of: tile, matching: find.byIcon(Icons.remove));
    await tester.tap(removeButton);
    await tester.pump();
    
    // Price back to 1.00
    expect(
        find.descendant(of: tile, matching: find.textContaining('Price: \$1.00')),
        findsOneWidget);
  });
  
  testWidgets('Selling to customer reduces stock and increases wallet', (WidgetTester tester) async {
    final player = Player(name: 'Seller', wallet: Wallet(10.0));
    final shop = Shop(
      inventory: Inventory(ingredients: {
        Recipes.sweetLemonade.outputIngredient: 5,
      }),
      wallet: Wallet(0.0),
      prices: {
         Recipes.sweetLemonade.outputIngredient: 2.00,
      },
    );
    player.addShop(shop);
    
    // Customer Alice wants Sweet Lemonade (from generateCustomers)
    
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(player: player),
        child: const MaterialApp(home: SellLemonadeScreen()),
      ),
    );

    // Initial Wallet check
    expect(find.text('Wallet: \$10.00'), findsOneWidget);
    
     // Find Alice card
    final aliceCard = find.ancestor(of: find.text('Alice'), matching: find.byType(Card));
    
    // Find Sell button
    final sellButton = find.descendant(of: aliceCard, matching: find.widgetWithText(ElevatedButton, 'Sell'));
    
    // Tap Sell
    await tester.tap(sellButton);
    await tester.pump();
    
    // Stock for Sweet Lemonade should decrease to 4
    expect(find.textContaining('Stock: 4'), findsOneWidget);
    
    // Alice should be gone
    expect(find.text('Alice'), findsNothing);
    
    // Check wallet updated: 10.00 + 2.00 = 12.00
    expect(find.text('Wallet: \$12.00'), findsOneWidget);
  });
}
