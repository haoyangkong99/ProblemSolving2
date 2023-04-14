import 'package:intl/intl.dart';

DateTime convertToDateTime(String? time) {
  return DateTime.parse(time!);
}

String formateTime(DateTime dt) {
  final timeFormatter = DateFormat('h:mm a');

  return timeFormatter.format(dt);
}

String formateDate(DateTime dt) {
  final dateFormatter = DateFormat('dd/MM/yy');

  return dateFormatter.format(dt);
}

String formateDateTime(DateTime dt) {
  final dateFormatter = DateFormat('dd/MM/yy\nh:mm a');

  return dateFormatter.format(dt);
}
