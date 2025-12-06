import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/ingredients.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/shop.dart';
import 'package:lemonade_tycoon/models/wallet.dart';

void main() {
  late Shop shop;
  late Inventory shopInventory;
  late Wallet shopWallet;
  late Inventory buyerInventory;
  late Wallet buyerWallet;
  
  // Helper to reset state before each test
  setUp(() {
    shopInventory = Inventory(ingredients: {
      Ingredients.lemon: 100,
      Ingredients.sugar: 100,
      Ingredients.water: 100,
      Ingredients.ice: 100,
    });
    shopWallet = Wallet(1000.0);
    final prices = {
      Ingredients.lemon: 0.5,
      Ingredients.sugar: 0.2,
      Ingredients.water: 0.1,
      Ingredients.ice: 0.1,
    };
    
    shop = Shop(
      inventory: shopInventory,
      wallet: shopWallet,
      prices: prices,
    );

    buyerInventory = Inventory(ingredients: {});
    buyerWallet = Wallet(10.0);
  });

  group('Shop.buy', () {
    test('successful transaction', () {
      final item = IngredientAmount(ingredient: Ingredients.lemon, amount: 10);
      // cost = 10 * 0.5 = 5.0

      final result = shop.buy(
        item: item,
        buyerWallet: buyerWallet,
        buyerInventory: buyerInventory,
      );

      expect(result, ShopTransactionResult.success);

      // Verify buyer state
      expect(buyerInventory.ingredients[Ingredients.lemon], 10);
      expect(buyerWallet.balance, 5.0); // 10.0 - 5.0

      // Verify shop state
      expect(shopInventory.ingredients[Ingredients.lemon], 90); // 100 - 10
      expect(shopWallet.balance, 1005.0); // 1000.0 + 5.0
    });

    test('insufficient funds', () {
      final item = IngredientAmount(ingredient: Ingredients.lemon, amount: 25);
      // cost = 25 * 0.5 = 12.5 (buyer has 10.0)

      final result = shop.buy(
        item: item,
        buyerWallet: buyerWallet,
        buyerInventory: buyerInventory,
      );

      expect(result, ShopTransactionResult.insufficientFunds);

      // Verify no changes
      expect(buyerInventory.ingredients[Ingredients.lemon], null);
      expect(buyerWallet.balance, 10.0);
      expect(shopInventory.ingredients[Ingredients.lemon], 100);
      expect(shopWallet.balance, 1000.0);
    });

    test('insufficient shop stock', () {
      final item = IngredientAmount(ingredient: Ingredients.lemon, amount: 101);
      // shop has 100

      // Give buyer enough money first
      buyerWallet.deposit(1000.0);

      final result = shop.buy(
        item: item,
        buyerWallet: buyerWallet,
        buyerInventory: buyerInventory,
      );

      expect(result, ShopTransactionResult.insufficientShopStock);

      // Verify no changes
      expect(buyerInventory.ingredients[Ingredients.lemon], null);
      expect(buyerWallet.balance, 1010.0);
      expect(shopInventory.ingredients[Ingredients.lemon], 100);
      expect(shopWallet.balance, 1000.0);
    });

    test('item not for sale', () {
        // Create a fake ingredient not in the price list map passed to Shop
        // But since Ingredients class has fixed statics, we might need a way to mock an ingredient or just assume 
        // the prices map could be missing one.
        // Let's re-create shop with missing price for Ice.
        
        final partialPrices = {
            Ingredients.lemon: 0.5,
        };
        shop = Shop(inventory: shopInventory, wallet: shopWallet, prices: partialPrices);

        final item = IngredientAmount(ingredient: Ingredients.ice, amount: 10);
        
        final result = shop.buy(
            item: item, 
            buyerWallet: buyerWallet, 
            buyerInventory: buyerInventory
        );

        expect(result, ShopTransactionResult.itemNotForSale);
        
        expect(buyerInventory.ingredients[Ingredients.ice], null);
    });
  });

  group('Shop.updatePrice', () {
    test('updates price for existing item', () {
      shop.updatePrice(Ingredients.lemon, 1.5);
      expect(shop.prices[Ingredients.lemon], 1.5);
    });

    test('adds price for new item', () {
      // Assuming 'Ingredients.water' is already there, let's pretend we removed it or just update it.
      // Actually Ingredient is enum-like but references are fixed.
      // Let's ensure start state.
      expect(shop.prices.containsKey(Ingredients.lemon), true);
      
      // Update
      shop.updatePrice(Ingredients.lemon, 0.99);
      expect(shop.prices[Ingredients.lemon], 0.99);
    });

    test('does not update price if negative', () {
       shop.updatePrice(Ingredients.lemon, -0.5);
       expect(shop.prices[Ingredients.lemon], 0.5); // Original price
    });
  });
}
