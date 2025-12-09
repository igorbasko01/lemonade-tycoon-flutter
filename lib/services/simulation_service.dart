import 'dart:math';

import '../models/customer.dart';
import '../models/daily_report.dart';
import '../models/ingredients.dart';
import '../models/inventory.dart';
import '../models/player.dart';

import '../models/shop.dart';
import '../models/wallet.dart';

class SimulationService {
  final Random _random = Random();

  DailyReport simulateDay({
    required Player player,
    required Shop shop,
    required int dayNumber,
  }) {
    final double startingFunds = player.wallet.balance;
    int customersServed = 0;
    int potentialCustomers;
    Map<Ingredient, int> itemsSold = {};

    List<Ingredient> availableItems = [];
    for (var ingredient in shop.prices.keys) {
      final int amount = shop.inventory.ingredients[ingredient] ?? 0;
      for (int i = 0; i < amount; i++) {
        availableItems.add(ingredient);
      }
    }

    availableItems.shuffle(_random);
    potentialCustomers = _random.nextInt(availableItems.length + 1);

    for (int i = 0; i < potentialCustomers; i++) {
      final wantedIngredient = availableItems[i];
      final customer = _createCustomerWithWant(wantedIngredient);

      final result = player.sellToCustomer(shop: shop, customer: customer);

      if (result == ShopTransactionResult.success) {
        customersServed++;
        itemsSold.update(
          wantedIngredient,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }

    return DailyReport(
      dayNumber: dayNumber,
      startingFunds: startingFunds,
      endingFunds: player.wallet.balance,
      customersServed: customersServed,
      potentialCustomers: potentialCustomers,
      itemsSold: itemsSold,
    );
  }

  Customer _createCustomerWithWant(Ingredient want) {
    return Customer(
      name: "Customer ${_random.nextInt(1000)}",
      wallet: Wallet(10.0 + _random.nextInt(50).toDouble()), // Has $10-60
      inventory: Inventory(ingredients: {}),
      wantedItem: IngredientAmount(ingredient: want, amount: 1),
    );
  }
}
