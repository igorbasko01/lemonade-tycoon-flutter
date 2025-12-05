import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/ingredients.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/recipes.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';

void main() {
  late Player player;
  late Wallet playerWallet;
  late Shop shop;
  late Wallet shopWallet;
  late Inventory shopInventory;

  setUp(() {
    playerWallet = Wallet(100.0);
    player = Player(
      name: 'Tycoon',
      wallet: playerWallet,
    );

    shopWallet = Wallet(50.0);
    shopInventory = Inventory(ingredients: {
      Ingredients.lemon: 5,
      Ingredients.sugar: 5,
      Ingredients.water: 5,
    });
    shop = Shop(
      inventory: shopInventory,
      wallet: shopWallet,
      prices: {Ingredients.lemon: 2.0}, // Selling price
    );
    player.addShop(shop);
  });

  group('Player.produce', () {
    test('successfully produces lemonade in specific shop', () {
      final recipe = Recipe(
        name: 'Lemonade',
        requiredIngredients: [
          IngredientAmount(ingredient: Ingredients.lemon, amount: 2),
        ],
        outputIngredient: Ingredient(name: 'Lemonade Product'),
      );

      final result = player.produce(recipe, shop);

      expect(result, true);
      expect(shop.inventory.ingredients[Ingredients.lemon], 3); // 5 - 2
      expect(shop.inventory.ingredients[recipe.outputIngredient], 1);
    });
  });

  group('Player Funds Transfer', () {
    test('transferToShop moves funds from player to shop', () {
      final success = player.transferToShop(shop, 20.0);
      
      expect(success, true);
      expect(player.wallet.balance, 80.0); // 100 - 20
      expect(shop.wallet.balance, 70.0);   // 50 + 20
    });

    test('transferToShop fails if insufficient funds', () {
      final success = player.transferToShop(shop, 200.0);
      
      expect(success, false);
      expect(player.wallet.balance, 100.0);
      expect(shop.wallet.balance, 50.0);
    });

    test('collectFromShop moves funds from shop to player', () {
      final success = player.collectFromShop(shop, 20.0);
      
      expect(success, true);
      expect(player.wallet.balance, 120.0); // 100 + 20
      expect(shop.wallet.balance, 30.0);   // 50 - 20
    });

     test('collectFromShop fails if insufficient funds in shop', () {
      final success = player.collectFromShop(shop, 60.0);
      
      expect(success, false);
      expect(player.wallet.balance, 100.0);
      expect(shop.wallet.balance, 50.0);
    });
  });

  group('Player.buyForShop', () {
    test('shop buys from supplier using shop funds', () {
      final supplierInventory = Inventory(ingredients: {Ingredients.ice: 10});
      final supplierWallet = Wallet(0.0);
      final supplier = Shop(
        inventory: supplierInventory,
        wallet: supplierWallet,
        prices: {Ingredients.ice: 0.5},
      );

      final result = player.buyForShop(
        supplier: supplier,
        targetShop: shop,
        item: IngredientAmount(ingredient: Ingredients.ice, amount: 2),
      );

      expect(result, ShopTransactionResult.success);
      expect(shop.inventory.ingredients[Ingredients.ice], 2);
      expect(shop.wallet.balance, 49.0); // 50 - 1.0
      expect(supplier.wallet.balance, 1.0);
    });
  });
}
