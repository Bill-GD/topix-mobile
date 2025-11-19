import 'package:flutter/foundation.dart';

import 'package:get_it/get_it.dart' show GetIt;

import 'package:topix/utils/services/token_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool hidePassword = true;

  void togglePasswordVisibility() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  Future<String?> tryGetToken(TokenType type) async {
    return GetIt.I<TokenService>().tryGet(type);
  }
}
