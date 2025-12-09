import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/game_view_model.dart';

class SetPricesScreen extends StatelessWidget {
  const SetPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Prices')),
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          final recipes = viewModel.recipes;
          final sellingPrices = viewModel.sellingPrices;
          final playerInventory = viewModel.playerInventory;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final product = recipe.outputIngredient;
              final price = sellingPrices[product] ?? 0.0;
              final stock = playerInventory[product] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('In Stock: $stock'),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (price > 0.05) {
                                    viewModel.updatePrice(
                                      product,
                                      price - 0.10,
                                    );
                                  } else {
                                    viewModel.updatePrice(product, 0.0);
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                '\$${price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  viewModel.updatePrice(product, price + 0.10);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
