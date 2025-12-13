import 'dart:math';

import '../../../models/daily_report.dart';
import '../../../models/ingredients.dart';
import '../../../models/customer.dart';
import '../../../models/inventory.dart';
import '../../../models/wallet.dart';
import '../../../models/shop.dart';
import 'simulation_strategy.dart';

class WeatherBasedSimulationStrategy implements SimulationStrategy {
  final Random _random = Random();

  @override
  DailyReport run(SimulationContext context) {
    final player = context.player;
    final shop = context.shop;
    final startingFunds = player.wallet.balance;
    int customersServed = 0;
    int potentialCustomers;
    Map<Ingredient, int> itemsSold = {};

    // 1. Calculate Base Traffic (10-30 people) + Weather Multiplier
    int baseTraffic = 10 + _random.nextInt(21);
    potentialCustomers = (baseTraffic * context.weather.customerMultiplier)
        .round();

    // Products the shop intends to sell (even if out of stock)
    List<Ingredient> productList = shop.prices.keys.toList();

    if (productList.isEmpty) {
      potentialCustomers = 0;
    }

    for (int i = 0; i < potentialCustomers; i++) {
      // Pick what they want from the menu
      final wantedIngredient = productList[_random.nextInt(productList.length)];
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
      dayNumber: context.dayNumber,
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
      wallet: Wallet(10.0 + _random.nextInt(50).toDouble()),
      inventory: Inventory(ingredients: {}),
      wantedItem: IngredientAmount(ingredient: want, amount: 1),
    );
  }
}
