import 'package:intl/intl.dart';

String formatTransactionCurrency(num number) {
  return NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 0,
  ).format(number);
}
