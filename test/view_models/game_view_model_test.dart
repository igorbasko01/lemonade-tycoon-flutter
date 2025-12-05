import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/player.dart';
import 'package:lemonade_tycoon/models/wallet.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';

void main() {
  test('GameViewModel initializes with default balance', () {
    final viewModel = GameViewModel();
    expect(viewModel.balance, 10.0);
  });

  test('GameViewModel allows injecting player', () {
    final player = Player(
      name: 'Test',
      wallet: Wallet(500.0),
    );
    final viewModel = GameViewModel(player: player);
    expect(viewModel.balance, 500.0);
  });
}
