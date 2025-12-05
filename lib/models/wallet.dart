class Wallet {
  double _balance;
  double get balance => _balance;

  Wallet(this._balance);

  void deposit(double amount) {
    _balance += amount;
  }

  bool withdraw(double amount) {
    if (amount > _balance) {
      return false;
    }
    _balance -= amount;
    return true;
  }
}