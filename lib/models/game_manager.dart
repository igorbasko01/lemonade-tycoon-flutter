import '../services/simulation/simulation_service.dart';
import '../services/weather_service.dart';
import 'daily_report.dart';
import 'ingredients.dart';
import 'inventory.dart';
import 'player.dart';
import 'recipes.dart';
import 'shop.dart';
import 'wallet.dart';
import 'weather.dart';

enum GamePhase { morning, day, evening }

class GameManager {
  int _currentDay = 0;
  GamePhase _currentPhase = GamePhase.morning;
  DailyReport? _lastDailyReport;

  late final Player _player;
  late final Shop _supplier;
  late final SimulationService _simulationService;
  late final WeatherService _weatherService;

  GameManager({
    Player? player,
    Shop? supplier,
    SimulationService? simulationService,
    WeatherService? weatherService,
  }) {
    _simulationService = simulationService ?? SimulationService();
    _weatherService = weatherService ?? WeatherService();

    if (player != null) {
      _player = player;
    } else {
      // Default initialization
      _player = Player(
        name: 'Tycoon',
        wallet: Wallet(10.0), // Starting balance
      );
      // We need to ensure the player has a shop to store ingredients
      _player.addShop(
        Shop(
          inventory: Inventory(ingredients: {}),
          wallet: Wallet(
            0.0,
          ), // Shop starts with 0 funds, player transfers money
          prices: {},
        ),
      );
    }

    if (supplier != null) {
      _supplier = supplier;
    } else {
      _supplier = Shop(
        inventory: Inventory(
          ingredients: {
            Ingredients.lemon: 1000,
            Ingredients.sugar: 1000,
            Ingredients.ice: 1000,
            Ingredients.water: 1000,
          },
        ),
        wallet: Wallet(0.0),
        prices: {
          Ingredients.lemon: 0.5,
          Ingredients.sugar: 0.25,
          Ingredients.ice: 0.1,
          Ingredients.water: 0.05,
        },
      );
    }
  }

  int get currentDay => _currentDay;
  GamePhase get currentPhase => _currentPhase;
  DailyReport? get lastDailyReport => _lastDailyReport;

  // --- Exposed Properties ---

  double get balance => _player.wallet.balance;
  WeatherType get currentWeather => _weatherService.currentWeather;

  Map<Ingredient, int> get playerInventory =>
      _player.shops.isNotEmpty ? _player.shops.first.inventory.ingredients : {};

  Map<Ingredient, double> get supplierPrices => _supplier.prices;

  Map<Ingredient, double> get sellingPrices =>
      _player.shops.isNotEmpty ? _player.shops.first.prices : {};

  // Used for testing or advanced scenarios where we need to inspect specific internals.
  // We keep it strictly for scenarios where deep inspection is needed, but generally prefer properties.
  // For tests that need to inject/setup, the constructor is used.

  // --- Actions ---

  void startMorning() {
    _currentDay++;
    _currentPhase = GamePhase.morning;
    _weatherService.startDay();
  }

  void startDay() {
    _currentPhase = GamePhase.day;

    // Run instant simulation
    final report = _simulationService.simulateDay(
      player: _player,
      shop: _player.shops.first,
      dayNumber: _currentDay,
      weather: _weatherService.currentWeather,
    );

    endDay(report);
  }

  void endDay(DailyReport report) {
    _lastDailyReport = report;
    _currentPhase = GamePhase.evening;
  }

  bool canPrepare(Recipe recipe) {
    if (_player.shops.isEmpty) return false;
    final shop = _player.shops.first;
    return recipe.canPrepare(shop.inventory);
  }

  void prepare(Recipe recipe) {
    if (_player.shops.isEmpty) return;
    // We assume production happens in the main shop for now
    _player.produce(recipe, _player.shops.first);
  }

  void buyIngredient(Ingredient ingredient) {
    if (_player.shops.isEmpty) return;

    final targetShop = _player.shops.first;
    final item = IngredientAmount(ingredient: ingredient, amount: 1);

    _player.buyForShop(
      supplier: _supplier,
      targetShop: targetShop,
      item: item,
      fundsSource: _player.wallet, // Pay directly from player wallet
    );
  }

  void updatePrice(Ingredient item, double newPrice) {
    if (_player.shops.isEmpty) return;
    if (newPrice < 0) return;

    final shop = _player.shops.first;
    shop.updatePrice(item, newPrice);
  }
}
