import 'package:intl/intl.dart';

String dateToMonthDate(DateTime date) {
  return DateFormat('MMMM dd').format(date);
}
