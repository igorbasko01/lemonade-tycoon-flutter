import 'ingredients.dart';
import 'inventory.dart';
import 'wallet.dart';

enum ShopTransactionResult {
  success,
  insufficientFunds,
  insufficientShopStock,
  itemNotForSale,
}

class Shop {
  final Inventory inventory;
  final Wallet wallet;
  final Map<Ingredient, double> prices;

  Shop({
    required this.inventory,
    required this.wallet,
    required this.prices,
  });

  ShopTransactionResult buy({
    required IngredientAmount item,
    required Wallet buyerWallet,
    required Inventory buyerInventory,
  }) {
    if (!prices.containsKey(item.ingredient)) {
      return ShopTransactionResult.itemNotForSale;
    }

    final pricePerUnit = prices[item.ingredient]!;
    final totalCost = pricePerUnit * item.amount;

    // Check if buyer has enough funds
    if (buyerWallet.balance < totalCost) {
      return ShopTransactionResult.insufficientFunds;
    }

    // Check if shop has enough stock
    final stockResult = inventory.hasIngredient(
      item.ingredient,
      minimumAmount: item.amount,
    );
    if (stockResult != HasIngredientResult.found) {
      return ShopTransactionResult.insufficientShopStock;
    }

    // Execute transaction
    // 1. Withdraw from shop inventory
    inventory.withdrawIngredient(item);
    // 2. Add to buyer inventory
    buyerInventory.addIngredient(item);
    // 3. Withdraw from buyer wallet (we already checked relevant funds)
    buyerWallet.withdraw(totalCost);
    // 4. Deposit to shop wallet
    wallet.deposit(totalCost);

    return ShopTransactionResult.success;
  }

  void updatePrice(Ingredient item, double price) {
    if (price < 0) return;
    prices[item] = price;
  }
}
