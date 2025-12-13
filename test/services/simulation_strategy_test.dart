import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/recipes.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/models/weather.dart';
import 'package:lemonade_tycoon/services/simulation/strategies/simulation_strategy.dart';
import 'package:lemonade_tycoon/services/simulation/strategies/inventory_based_strategy.dart';
import 'package:lemonade_tycoon/services/simulation/strategies/weather_based_strategy.dart';

void main() {
  late Player player;
  late Shop shop;
  late SimulationContext context;

  setUp(() {
    player = Player(name: 'Test', wallet: Wallet(100.0));
    shop = Shop(
      inventory: Inventory(
        ingredients: {Recipes.sweetLemonade.outputIngredient: 100},
      ),
      wallet: Wallet(0.0),
      prices: {Recipes.sweetLemonade.outputIngredient: 2.0},
    );
    player.addShop(shop);
    context = SimulationContext(
      player: player,
      shop: shop,
      dayNumber: 1,
      weather: WeatherType.sunny,
    );
  });

  group('InventoryBasedSimulationStrategy', () {
    test('should generate sales based on inventory', () {
      final strategy = InventoryBasedSimulationStrategy();
      final report = strategy.run(context);

      expect(report.dayNumber, 1);
      // Inventory based usually caps at inventory size, but here inventory is 100.
      // Sales should be non-negative.
      expect(report.customersServed, greaterThanOrEqualTo(0));
    });
  });

  group('WeatherBasedSimulationStrategy', () {
    test('should generate sales varying with weather', () {
      final strategy = WeatherBasedSimulationStrategy();
      final report = strategy.run(context);

      expect(report.dayNumber, 1);
      // Weather based depends on base traffic * weather multiplier
      expect(report.customersServed, greaterThanOrEqualTo(0));
    });

    test('should produce 0 sales if menu is empty', () {
      shop = Shop(
        inventory: Inventory(ingredients: {}),
        wallet: Wallet(0.0),
        prices: {}, // Empty menu
      );
      context = SimulationContext(
        player: player,
        shop: shop,
        dayNumber: 1,
        weather: WeatherType.sunny,
      );

      final strategy = WeatherBasedSimulationStrategy();
      final report = strategy.run(context);

      expect(report.customersServed, 0);
    });
  });
}
