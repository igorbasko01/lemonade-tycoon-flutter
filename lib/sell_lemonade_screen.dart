import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/game_view_model.dart';

class SellLemonadeScreen extends StatelessWidget {
  const SellLemonadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Lemonade'),
      ),
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          final recipes = viewModel.recipes;
          final sellingPrices = viewModel.sellingPrices;
          final customers = viewModel.customers;
          final playerInventory = viewModel.playerInventory;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Wallet: \$${viewModel.balance.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              // Pricing Section
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    final product = recipe.outputIngredient;
                    final price = sellingPrices[product] ?? 1.0; // Default $1.00
                    final stock = playerInventory[product] ?? 0;

                    return Card(
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text('Stock: $stock | Price: \$${price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                viewModel.updatePrice(product, price - 0.10);
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            IconButton(
                              onPressed: () {
                                viewModel.updatePrice(product, price + 0.10);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(thickness: 2),
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'Customers',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
              ),
              // Customers Section
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    final wantedItemName = customer.wantedItem.ingredient.name;
                    
                    // Logic to see if we can sell
                    // Needs stock and customer can afford (although affordability is hidden, we can just try sell)
                    // Let's at least check stock for UI feedback
                    final hasStock = (playerInventory[customer.wantedItem.ingredient] ?? 0) >= customer.wantedItem.amount;

                    return Card(
                      color: Colors.amber.shade50,
                      child: ListTile(
                        title: Text(customer.name),
                        subtitle: Text('Wants: $wantedItemName'),
                        trailing: ElevatedButton(
                          onPressed: hasStock 
                              ? () => viewModel.sellToCustomer(customer)
                              : null,
                          child: const Text('Sell'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
