import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/wallet.dart';

void main() {
  test('Wallet deposit increases balance', () {
    final wallet = Wallet(100.0);
    wallet.deposit(50.0);
    expect(wallet.balance, 150.0);
  });

  test('Wallet withdraw decreases balance when sufficient funds', () {
    final wallet = Wallet(100.0);
    final result = wallet.withdraw(40.0);
    expect(result, true);
    expect(wallet.balance, 60.0);
  });

  test('Wallet withdraw fails when insufficient funds', () {
    final wallet = Wallet(100.0);
    final result = wallet.withdraw(150.0);
    expect(result, false);
    expect(wallet.balance, 100.0);
  });
}