import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String get dateOnly {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
