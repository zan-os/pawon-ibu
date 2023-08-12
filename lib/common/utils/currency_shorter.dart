String? currencyShorter(int amount) {
  if (amount <= 0) {
    return null;
  } else if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(0)}jt';
  } else if (amount >= 1000) {
    return '${(amount / 1000).toStringAsFixed(0)}rb';
  } else if (amount < 1000) {
    return '$amount';
  } else {
    return null;
  }
}
