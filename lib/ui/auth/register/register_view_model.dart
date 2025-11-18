import 'package:flutter/foundation.dart';

enum PasswordType { normal, confirm }

class RegisterViewModel extends ChangeNotifier {
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void togglePasswordVisibility(PasswordType type) {
    switch (type) {
      case .normal:
        hidePassword = !hidePassword;
      case .confirm:
        hideConfirmPassword = !hideConfirmPassword;
    }
    notifyListeners();
  }
}
