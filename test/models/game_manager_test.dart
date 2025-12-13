import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/daily_report.dart';
import 'package:lemonade_tycoon/models/game_manager.dart';
import 'package:lemonade_tycoon/models/ingredients.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/recipes.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/models/weather.dart';
import 'package:lemonade_tycoon/services/simulation/simulation_service.dart';

class FakeSimulationService extends SimulationService {
  bool simulateCalled = false;

  @override
  DailyReport simulateDay({
    required Player player,
    required Shop shop,
    required int dayNumber,
    required WeatherType weather,
  }) {
    simulateCalled = true;
    return DailyReport(
      dayNumber: dayNumber,
      startingFunds: 10,
      endingFunds: 20,
      customersServed: 5,
      potentialCustomers: 10,
      itemsSold: {},
    );
  }
}

void main() {
  late GameManager gameManager;
  late FakeSimulationService fakeSimulationService;
  late Player testPlayer;

  setUp(() {
    fakeSimulationService = FakeSimulationService();
    testPlayer = Player(name: 'Test', wallet: Wallet(10.0));
    testPlayer.addShop(
      Shop(
        inventory: Inventory(ingredients: {}),
        wallet: Wallet(0.0),
        prices: {},
      ),
    );

    // Re-initialize manager with fake service and test player
    gameManager = GameManager(
      simulationService: fakeSimulationService,
      player: testPlayer,
    );

    // Give player some money for buying tests via the direct reference
    testPlayer.wallet.deposit(100.0);
  });

  test('Initial state should be Morning Day 0', () {
    expect(gameManager.currentDay, 0);
    expect(gameManager.currentPhase, GamePhase.morning);
  });

  test('startDay should run simulation and move to Evening phase', () {
    gameManager.startMorning(); // Move to Day 1
    gameManager.startDay();
    expect(gameManager.currentPhase, GamePhase.evening);
    expect(gameManager.currentDay, 1);
    expect(fakeSimulationService.simulateCalled, true);
  });

  test('buyIngredient should update inventory and wallet', () {
    // Player starts with empty inventory
    expect(gameManager.playerInventory[Ingredients.lemon] ?? 0, 0);

    gameManager.buyIngredient(Ingredients.lemon);

    expect(gameManager.playerInventory[Ingredients.lemon], 1);
    // Price of lemon is 0.5 (from default supplier), wallet started at 110.0 (10 + 100)
    expect(gameManager.balance, 109.5);
  });

  test('updatePrice should update shop prices', () {
    gameManager.updatePrice(Ingredients.lemon, 1.5);
    expect(gameManager.sellingPrices[Ingredients.lemon], 1.5);
  });

  test('prepare should produce lemonade if ingredients exist', () {
    // Add ingredients manually for the test
    testPlayer.shops.first.inventory.addIngredient(
      IngredientAmount(ingredient: Ingredients.lemon, amount: 1),
    );
    testPlayer.shops.first.inventory.addIngredient(
      IngredientAmount(ingredient: Ingredients.sugar, amount: 4),
    ); // Recipe needs 4 sugar
    testPlayer.shops.first.inventory.addIngredient(
      IngredientAmount(ingredient: Ingredients.water, amount: 1),
    );
    testPlayer.shops.first.inventory.addIngredient(
      IngredientAmount(ingredient: Ingredients.ice, amount: 1),
    );

    expect(gameManager.canPrepare(Recipes.sweetLemonade), true);

    gameManager.prepare(Recipes.sweetLemonade);

    // Ingredients consumed
    expect(gameManager.playerInventory[Ingredients.lemon] ?? 0, 0);
  });
}
