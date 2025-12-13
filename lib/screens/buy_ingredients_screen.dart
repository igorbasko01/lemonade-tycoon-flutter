import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/game_view_model.dart';

class BuyIngredientsScreen extends StatelessWidget {
  const BuyIngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy Ingredients')),
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          final supplierPrices = viewModel.supplierPrices;
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
              Expanded(
                child: ListView.builder(
                  itemCount: supplierPrices.length,
                  itemBuilder: (context, index) {
                    final ingredient = supplierPrices.keys.elementAt(index);
                    final price = supplierPrices[ingredient]!;
                    final ownedAmount = playerInventory[ingredient] ?? 0;

                    final canAfford = viewModel.balance >= price;

                    return ListTile(
                      title: Text(ingredient.name.toUpperCase()),
                      subtitle: Text(
                        'Price: \$${price.toStringAsFixed(2)} | Owned: $ownedAmount',
                      ),
                      trailing: ElevatedButton(
                        onPressed: canAfford
                            ? () {
                                viewModel.buyIngredient(ingredient);
                              }
                            : null,
                        child: const Text('Buy 1'),
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
