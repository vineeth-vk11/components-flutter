import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Debug {
  static void log(String message) {
    final format = DateFormat('HH:mm:ss');
    if (kDebugMode) {
      print('${format.format(DateTime.now())}: $message');
    }
  }
}
