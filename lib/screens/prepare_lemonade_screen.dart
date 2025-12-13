import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/game_view_model.dart';

class PrepareLemonadeScreen extends StatelessWidget {
  const PrepareLemonadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prepare Lemonade')),
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          final recipes = viewModel.recipes;
          final playerInventory = viewModel.playerInventory;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final canPrepare = viewModel.canPrepare(recipe);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recipe.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'In Stock: ${playerInventory[recipe.outputIngredient] ?? 0}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Required Ingredients:'),
                      ...recipe.requiredIngredients.map((req) {
                        final owned = playerInventory[req.ingredient] ?? 0;
                        final hasEnough = owned >= req.amount;
                        return Text(
                          '- ${req.ingredient.name.toUpperCase()}: ${req.amount} (Owned: $owned)',
                          style: TextStyle(
                            color: hasEnough ? Colors.green : Colors.red,
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: canPrepare
                              ? () {
                                  viewModel.prepare(recipe);
                                }
                              : null,
                          child: const Text('Prepare'),
                        ),
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
