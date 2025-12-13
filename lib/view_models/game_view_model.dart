import 'package:flutter/foundation.dart';
import '../models/ingredients.dart';
import '../models/game_manager.dart';
import '../models/recipes.dart';
import '../models/weather.dart';

class GameViewModel extends ChangeNotifier {
  late final GameManager _gameManager;

  GameViewModel({required GameManager gameManager})
    : _gameManager = gameManager {
    // If we are starting fresh (Day 0), begin the morning of Day 1
    if (_gameManager.currentDay == 0) {
      _gameManager.startMorning();
    }
  }

  GameManager get gameManager => _gameManager;

  // Direct access via Demeter-compliant getters
  double get balance => _gameManager.balance;
  WeatherType get currentWeather => _gameManager.currentWeather;

  // Expose supplier data
  Map<Ingredient, double> get supplierPrices => _gameManager.supplierPrices;

  // Expose player's main shop inventory
  Map<Ingredient, int> get playerInventory => _gameManager.playerInventory;

  List<Recipe> get recipes => Recipes.all;

  bool canPrepare(Recipe recipe) => _gameManager.canPrepare(recipe);

  void prepare(Recipe recipe) {
    _gameManager.prepare(recipe);
    notifyListeners();
  }

  void buyIngredient(Ingredient ingredient) {
    _gameManager.buyIngredient(ingredient);
    notifyListeners();
  }

  Map<Ingredient, double> get sellingPrices => _gameManager.sellingPrices;

  void updatePrice(Ingredient item, double newPrice) {
    _gameManager.updatePrice(item, newPrice);
    notifyListeners();
  }

  void startDaySimulation() {
    _gameManager.startDay();
    notifyListeners();
  }

  void nextMorning() {
    _gameManager.startMorning();
    notifyListeners();
  }
}
