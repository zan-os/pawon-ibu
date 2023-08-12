import 'package:intl/intl.dart';

String dateTimeFormatter(DateTime createdAt) {
  final formattedDate = DateFormat('yyyy-MM-dd').format(createdAt);
  return formattedDate;
}
