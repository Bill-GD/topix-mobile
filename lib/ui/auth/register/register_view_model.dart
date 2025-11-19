import 'package:flutter/foundation.dart';

enum PasswordType { normal, confirm }

class RegisterViewModel extends ChangeNotifier {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  final bool _isGoogleOAuth;

  RegisterViewModel({bool isGoogleOAuth = false}) : _isGoogleOAuth = isGoogleOAuth;

  bool get hidePassword => _hidePassword;

  bool get hideConfirmPassword => _hideConfirmPassword;

  bool get isGoogleOAuth => _isGoogleOAuth;

  void togglePasswordVisibility(PasswordType type) {
    switch (type) {
      case .normal:
        _hidePassword = !_hidePassword;
      case .confirm:
        _hideConfirmPassword = !_hideConfirmPassword;
    }
    notifyListeners();
  }
}
