import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  bool hidePassword = true;

  void togglePasswordVisibility() {
    hidePassword = !hidePassword;
    notifyListeners();
  }
}
