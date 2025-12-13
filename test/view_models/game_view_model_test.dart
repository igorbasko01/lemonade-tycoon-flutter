import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/game_manager.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';

void main() {
  test('GameViewModel initializes with default manager', () {
    final gameManager = GameManager();
    final viewModel = GameViewModel(gameManager: gameManager);
    expect(viewModel.balance, 10.0);
  });

  test('GameViewModel uses manager player', () {
    final player = Player(name: 'Test', wallet: Wallet(500.0));
    final gameManager = GameManager(player: player);
    final viewModel = GameViewModel(gameManager: gameManager);
    expect(viewModel.balance, 500.0);
  });
}
