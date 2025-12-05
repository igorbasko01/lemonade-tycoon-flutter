import 'package:flutter/material.dart';

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
            ElevatedButton(
              onPressed: () {
                // TODO: Implement Buy Ingredients
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
