import 'package:flutter/foundation.dart';

class PermissionContext extends ChangeNotifier {
  bool _isGranted = false;
  bool get isGranted => _isGranted;

  void setGranted(bool granted) {
    _isGranted = granted;
    notifyListeners();
  }
}
