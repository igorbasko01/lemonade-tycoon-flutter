import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/ingredients.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/recipes.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/services/simulation_service.dart';

void main() {
  late SimulationService service;
  late Player player;
  late Shop shop;

  setUp(() {
    service = SimulationService();
    // Setup player with a shop and some inventory/money
    player = Player(name: 'Test', wallet: Wallet(100.0));
    shop = Shop(
      inventory: Inventory(
        ingredients: {
          Recipes.sweetLemonade.outputIngredient: 100, // Plenty of stock
        },
      ),
      wallet: Wallet(0.0),
      prices: {
        Recipes.sweetLemonade.outputIngredient: 2.0, // Selling for $2
      },
    );
    player.addShop(shop);
  });

  test('simulateDay should generate sales and revenue', () {
    final report = service.simulateDay(
      player: player,
      shop: shop,
      dayNumber: 1,
    );

    // We can't predict exact numbers due to randomness, but:
    // 1. Starting funds should match
    expect(report.startingFunds, 100.0);

    // 2. Ending funds should be higher (since we have stock and customers)
    // Note: It's theoretically possible to get 0 customers if randomness is extremely unlucky,
    // but with 10-19 customers, it's very unlikely none buy if we have the item.
    // However, our simulation logic for MVP picks a random recipe.
    // We only stock "Sweet Lemonade".
    // If customers want other lemonades, they won't buy.
    // So distinct possibility of 0 sales if all customers want other types.
    // To fix this test flake, let's stock ALL types.

    shop.inventory.addIngredient(
      IngredientAmount(
        ingredient: Recipes.mildLemonade.outputIngredient,
        amount: 100,
      ),
    );
    shop.inventory.addIngredient(
      IngredientAmount(
        ingredient: Recipes.refreshingLemonade.outputIngredient,
        amount: 100,
      ),
    );

    shop.updatePrice(Recipes.mildLemonade.outputIngredient, 2.0);
    shop.updatePrice(Recipes.refreshingLemonade.outputIngredient, 2.0);

    // Re-run simulation with full stock
    final report2 = service.simulateDay(
      player: player,
      shop: shop,
      dayNumber: 1,
    );

    expect(report2.endingFunds, greaterThan(report2.startingFunds));
    expect(report2.customersServed, greaterThan(0));
    expect(report2.itemsSold, isNotEmpty);
  });

  test('simulateDay with no prices set should result in zero sales', () {
    // Clear prices
    shop = Shop(
      inventory: Inventory(
        ingredients: {Recipes.sweetLemonade.outputIngredient: 100},
      ),
      wallet: Wallet(0.0),
      prices: {},
    );

    final report = service.simulateDay(
      player: player,
      shop: shop,
      dayNumber: 1,
    );

    expect(report.startingFunds, 100.0);
    expect(report.endingFunds, 100.0);
    expect(report.customersServed, 0);
    expect(report.itemsSold, isEmpty);
  });

  test('simulateDay with no inventory should result in zero sales', () {
    // Inventory is empty
    shop = Shop(
      inventory: Inventory(ingredients: {}),
      wallet: Wallet(0.0),
      prices: {Recipes.sweetLemonade.outputIngredient: 2.0},
    );

    final report = service.simulateDay(
      player: player,
      shop: shop,
      dayNumber: 1,
    );

    expect(report.startingFunds, 100.0);
    expect(report.endingFunds, 100.0);
    expect(report.customersServed, 0);
    expect(report.itemsSold, isEmpty);
  });

  test(
    'simulateDay with partial inventory should only sell available items',
    () {
      // Prices for Sweet and Mild
      // Inventory only for Sweet
      final sweet = Recipes.sweetLemonade.outputIngredient;
      final mild = Recipes.mildLemonade.outputIngredient;

      shop = Shop(
        inventory: Inventory(
          ingredients: {
            sweet: 100,
            mild: 0, // Explicitly 0
          },
        ),
        wallet: Wallet(0.0),
        prices: {sweet: 2.0, mild: 2.0},
      );

      final report = service.simulateDay(
        player: player,
        shop: shop,
        dayNumber: 1,
      );

      // Verify correct sales
      expect(report.itemsSold.containsKey(sweet), isTrue);
      expect(report.itemsSold[sweet]!, greaterThan(0));
      expect(report.itemsSold.containsKey(mild), isFalse);

      // Ensure we made money
      expect(report.endingFunds, greaterThan(report.startingFunds));
    },
  );
}
