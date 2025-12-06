import 'customer.dart';
import 'ingredients.dart';
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
    Wallet? fundsSource,
  }) {
    return supplier.buy(
      item: item,
      buyerWallet: fundsSource ?? targetShop.wallet,
      buyerInventory: targetShop.inventory,
    );
  }

  ShopTransactionResult sellToCustomer({
    required Shop shop,
    required Customer customer,
  }) {
     // Ensure we have a price for the item
     if (!shop.prices.containsKey(customer.wantedItem.ingredient)) {
       shop.updatePrice(customer.wantedItem.ingredient, 1.0);
     }

     final price = shop.prices[customer.wantedItem.ingredient]!;
     
     // We can reuse Shop.buy logic here but reversed? 
     // Shop.buy is "buy FROM this shop".
     // Here "Customer buys FROM this shop".
     // So... shop.buy(item: wanted, buyerWallet: customer, buyerInv: customer)
     // Yes, Shop.buy is designed exactly for this direction!
     
     final result = shop.buy(
       item: customer.wantedItem,
       buyerWallet: customer.wallet,
       buyerInventory: customer.inventory,
     );

     if (result == ShopTransactionResult.success) {
       // Automate collection
       final income = price * customer.wantedItem.amount;
       collectFromShop(shop, income);
     }

     return result;
  }
}
