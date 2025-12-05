import 'ingredients.dart';
import 'inventory.dart';
import 'recipes.dart';
import 'shop.dart';
import 'wallet.dart';

class Player {
  final String name;
  final Wallet wallet;
  final List<Shop> shops = [];

  Player({
    required this.name,
    required this.wallet,
  });

  void addShop(Shop shop) {
    shops.add(shop);
  }

  bool transferToShop(Shop shop, double amount) {
    if (wallet.withdraw(amount)) {
      shop.wallet.deposit(amount);
      return true;
    }
    return false;
  }

  bool collectFromShop(Shop shop, double amount) {
    if (shop.wallet.withdraw(amount)) {
      wallet.deposit(amount);
      return true;
    }
    return false;
  }

  bool produce(Recipe recipe, Shop shop) {
    return recipe.prepare(shop.inventory);
  }

  ShopTransactionResult buyForShop({
    required Shop supplier,
    required Shop targetShop,
    required IngredientAmount item,
  }) {
    return supplier.buy(
      item: item,
      buyerWallet: targetShop.wallet,
      buyerInventory: targetShop.inventory,
    );
  }
}
