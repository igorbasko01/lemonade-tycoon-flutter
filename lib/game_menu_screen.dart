import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buy_ingredients_screen.dart';
import 'view_models/game_view_model.dart';

class GameMenuScreen extends StatelessWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lemonade Tycoon'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<GameViewModel>(
              builder: (context, viewModel, child) {
                return Text(
                  'Balance: \$${viewModel.balance.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BuyIngredientsScreen(),
                  ),
                );
              },
              child: const Text('Buy Ingredients'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 // TODO: Implement Prepare Lemonade
              },
              child: const Text('Prepare Lemonade'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 // TODO: Implement Sell Lemonade
              },
              child: const Text('Sell Lemonade'),
            ),
          ],
        ),
      ),
    );
  }
}
