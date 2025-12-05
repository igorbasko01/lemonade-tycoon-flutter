import 'ingredients.dart';
import 'inventory.dart';
import 'wallet.dart';

enum PurchaseResult {
  success,
  insufficientFunds,
  insufficientSellerStock,
}

class Customer {
  final Wallet wallet;
  final Inventory inventory;
  final IngredientAmount wantedItem;

  Customer({
    required this.wallet,
    required this.inventory,
    required this.wantedItem,
  });

  bool canAfford(double price) {
    return wallet.balance >= price * wantedItem.amount;
  }

  PurchaseResult purchase({
    required Inventory sellerInventory,
    required Wallet sellerWallet,
    required double pricePerUnit,
  }) {
    final totalCost = pricePerUnit * wantedItem.amount;

    if (!canAfford(pricePerUnit)) {
      return PurchaseResult.insufficientFunds;
    }

    final hasStock = sellerInventory.hasIngredient(
      wantedItem.ingredient,
      minimumAmount: wantedItem.amount,
    );

    if (hasStock != HasIngredientResult.found) {
      return PurchaseResult.insufficientSellerStock;
    }

    // Execute transaction
    sellerInventory.withdrawIngredient(wantedItem);
    inventory.addIngredient(wantedItem);
    wallet.withdraw(totalCost);
    sellerWallet.deposit(totalCost);

    return PurchaseResult.success;
  }
}
