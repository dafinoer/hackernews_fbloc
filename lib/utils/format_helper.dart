


import 'package:intl/intl.dart';

class FormatHelper {

  static String simpelFormat(DateTime time) {
    final format = DateFormat.yMd();
    return format.format(time);
  }
}