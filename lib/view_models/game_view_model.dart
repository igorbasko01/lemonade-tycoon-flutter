import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/wallet.dart';

class GameViewModel extends ChangeNotifier {
  late final Player _player;

  GameViewModel({Player? player}) {
    if (player != null) {
      _player = player;
    } else {
      // Default initialization
      _player = Player(
        name: 'Tycoon',
        wallet: Wallet(10.0), // Starting balance
      );
    }
  }

  double get balance => _player.wallet.balance;

  // Placeholder for future methods that modify state
  void refreshState() {
    notifyListeners();
  }
}
