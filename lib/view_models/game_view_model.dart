import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../models/ingredients.dart';
import '../models/inventory.dart';
import '../models/player.dart';
import '../models/recipes.dart';
import '../models/shop.dart';
import '../models/wallet.dart';

class GameViewModel extends ChangeNotifier {
  late final Player _player;

  late final Shop _supplier;

  GameViewModel({Player? player, Shop? supplier}) {
    if (player != null) {
      _player = player;
    } else {
      // Default initialization
      _player = Player(
        name: 'Tycoon',
        wallet: Wallet(10.0), // Starting balance
      );
      // We need to ensure the player has a shop to store ingredients
      _player.addShop(Shop(
        inventory: Inventory(ingredients: {}),
        wallet: Wallet(0.0), // Shop starts with 0 funds, player transfers money
        prices: {},
      ));
    }

    if (supplier != null) {
      _supplier = supplier;
    } else {
      _supplier = Shop(
        inventory: Inventory(ingredients: {
          Ingredients.lemon: 1000,
          Ingredients.sugar: 1000,
          Ingredients.ice: 1000,
          Ingredients.water: 1000,
        }),
        wallet: Wallet(0.0),
        prices: {
          Ingredients.lemon: 0.5,
          Ingredients.sugar: 0.25,
          Ingredients.ice: 0.1,
          Ingredients.water: 0.05,
        },
      );
    }
    
    generateCustomers();
  }

  double get balance => _player.wallet.balance;
  
  // Expose supplier data
  Map<Ingredient, double> get supplierPrices => _supplier.prices;
  
  // Expose player's main shop inventory (assuming first shop is main)
  // If player has no shops, we return empty map or handle error. 
  // Based on init above, player should have a shop.
  Map<Ingredient, int> get playerInventory => 
      _player.shops.isNotEmpty ? _player.shops.first.inventory.ingredients : {};

  List<Recipe> get recipes => Recipes.all;

  bool canPrepare(Recipe recipe) {
    if (_player.shops.isEmpty) return false;
    final shop = _player.shops.first;
    return recipe.canPrepare(shop.inventory);
  }

  void prepare(Recipe recipe) {
    if (_player.shops.isEmpty) return;
    
    // We assume production happens in the main shop for now
    if (_player.produce(recipe, _player.shops.first)) {
      notifyListeners();
    }
  }

  void buyIngredient(Ingredient ingredient) {
    if (_player.shops.isEmpty) return;

    final targetShop = _player.shops.first;
    final item = IngredientAmount(ingredient: ingredient, amount: 1);
    

    final result = _player.buyForShop(
       supplier: _supplier, 
       targetShop: targetShop, 
       item: item,
       fundsSource: _player.wallet, // Pay directly from player wallet
     );

     if (result == ShopTransactionResult.success) {
       notifyListeners();
     }
  }


  List<Customer> _customers = [];
  List<Customer> get customers => List.unmodifiable(_customers);

  void generateCustomers() {
     // Simple generator for now
     // In a real game this would be more complex
     _customers = [
       Customer(
         name: 'Alice',
         wallet: Wallet(5.0),
         inventory: Inventory(ingredients: {}),
         wantedItem: IngredientAmount(ingredient: Recipes.sweetLemonade.outputIngredient, amount: 1),
       ),
       Customer(
         name: 'Bob',
         wallet: Wallet(3.0),
         inventory: Inventory(ingredients: {}),
         wantedItem: IngredientAmount(ingredient: Recipes.mildLemonade.outputIngredient, amount: 1),
       ),
       Customer(
          name: 'Charlie',
          wallet: Wallet(4.0),
          inventory: Inventory(ingredients: {}),
          wantedItem: IngredientAmount(ingredient: Recipes.refreshingLemonade.outputIngredient, amount: 1),
       ),
     ];
  }

  Map<Ingredient, double> get sellingPrices => 
    _player.shops.isNotEmpty ? _player.shops.first.prices : {};

  void updatePrice(Ingredient item, double newPrice) {
    if (_player.shops.isEmpty) return;
    if (newPrice < 0) return;
    
    // Create new map to trigger listeners
    final shop = _player.shops.first;
    shop.updatePrice(item, newPrice);
    notifyListeners();
  }

  void sellToCustomer(Customer customer) {
     if (_player.shops.isEmpty) return;
     final shop = _player.shops.first;

     final result = _player.sellToCustomer(
       shop: shop,
       customer: customer,
     );

     if (result == ShopTransactionResult.success) {
       _customers.remove(customer);
       notifyListeners();
     }
  }
}
