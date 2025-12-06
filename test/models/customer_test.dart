import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/customer.dart';
import 'package:lemonade_tycoon/models/ingredients.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/wallet.dart';

void main() {
  late Customer customer;
  late Wallet customerWallet;
  late Inventory customerInventory;
  late Wallet sellerWallet;
  late Inventory sellerInventory;

  setUp(() {
    customerWallet = Wallet(10.0);
    customerInventory = Inventory(ingredients: {});
    sellerWallet = Wallet(100.0);
    sellerInventory = Inventory(ingredients: {
      Ingredients.lemon: 10,
    });

    customer = Customer(
      name: 'Test Buyer',
      wallet: customerWallet,
      inventory: customerInventory,
      wantedItem: IngredientAmount(ingredient: Ingredients.lemon, amount: 2),
    );
  });

  group('Customer.canAfford', () {
    test('returns true if sufficient funds', () {
      // 2 * 2.0 = 4.0 <= 10.0
      expect(customer.canAfford(2.0), true);
    });

    test('returns false if insufficient funds', () {
      // 2 * 6.0 = 12.0 > 10.0
      expect(customer.canAfford(6.0), false);
    });
  });

  group('Customer.purchase', () {
    test('transaction succeeds with sufficient funds and stock', () {
      final result = customer.purchase(
        sellerInventory: sellerInventory,
        sellerWallet: sellerWallet,
        pricePerUnit: 2.0,
      );

      expect(result, PurchaseResult.success);

      // Customer
      expect(customerInventory.ingredients[Ingredients.lemon], 2);
      expect(customerWallet.balance, 6.0); // 10 - 4

      // Seller
      expect(sellerInventory.ingredients[Ingredients.lemon], 8); // 10 - 2
      expect(sellerWallet.balance, 104.0); // 100 + 4
    });

    test('transaction fails if customer cannot afford', () {
       final result = customer.purchase(
        sellerInventory: sellerInventory,
        sellerWallet: sellerWallet,
        pricePerUnit: 6.0,
      );

      expect(result, PurchaseResult.insufficientFunds);

      // Unchanged
      expect(customerInventory.ingredients[Ingredients.lemon], null);
      expect(customerWallet.balance, 10.0);
      expect(sellerInventory.ingredients[Ingredients.lemon], 10);
      expect(sellerWallet.balance, 100.0);
    });

    test('transaction fails if seller has insufficient stock', () {
        // Set up customer wanting more than seller has
        customer = Customer(
            name: 'Greedy Buyer',
            wallet: customerWallet,
            inventory: customerInventory,
            wantedItem: IngredientAmount(ingredient: Ingredients.lemon, amount: 11), // Seller has 10
        );
        // Make sure customer has enough money
        customerWallet.deposit(100.0);

        final result = customer.purchase(
            sellerInventory: sellerInventory,
            sellerWallet: sellerWallet,
            pricePerUnit: 1.0,
        );

        expect(result, PurchaseResult.insufficientSellerStock);

        // Unchanged
        expect(customerInventory.ingredients[Ingredients.lemon], null);
        expect(sellerInventory.ingredients[Ingredients.lemon], 10);
    });
  });
}
