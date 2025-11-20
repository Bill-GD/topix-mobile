import 'package:flutter/foundation.dart';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:topix/data/services/logger_service.dart' show LoggerService;

enum PasswordType { normal, confirm }

class RegisterViewModel extends ChangeNotifier {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  GoogleSignInAccount? _oauthUser;

  bool get hidePassword => _hidePassword;

  bool get hideConfirmPassword => _hideConfirmPassword;

  bool get isGoogleOAuth => _oauthUser != null;

  GoogleSignInAccount? get googleAccount => _oauthUser;

  String get accountUsername {
    if (!isGoogleOAuth) return '';
    if (_oauthUser!.displayName != null) return _oauthUser!.displayName!;
    return _oauthUser!.email.split('@')[0];
  }

  void togglePasswordVisibility(PasswordType type) {
    switch (type) {
      case .normal:
        _hidePassword = !_hidePassword;
      case .confirm:
        _hideConfirmPassword = !_hideConfirmPassword;
    }
    notifyListeners();
  }

  Future<void> requestGoogleSignIn() async {
    LoggerService.log('Authenticating with Google');
    _oauthUser = await GetIt.I<GoogleSignIn>().authenticate();
    notifyListeners();
  }
}
