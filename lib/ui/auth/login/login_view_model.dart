import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  bool _hidePassword = true;

  bool get hidePassword => _hidePassword;

  void togglePasswordVisibility() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }
}
