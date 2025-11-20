import 'package:google_sign_in/google_sign_in.dart';

import 'package:topix/data/services/logger_service.dart';

class GoogleOAuthService {
  final GoogleSignIn _googleSignIn;

  GoogleOAuthService(this._googleSignIn);

  GoogleSignIn get googleSignIn => _googleSignIn;

  bool get supportsAuthenticate => _googleSignIn.supportsAuthenticate();

  Future<void> signIn() async {
    try {
      // _googleSignIn.authenticationEvents.listen((event) {
      //   final user = (event as GoogleSignInAuthenticationEventSignIn)
      //       .user; // `user` is a GoogleSignInAccount?
      //   print('Account: ${user.email}');
      //   print('Name: ${user.displayName}');
      //   print('Photo: ${user.photoUrl}');
      // });
      final user = await _googleSignIn.authenticate();
      LoggerService.log('$user');
    } on GoogleSignInException catch (e) {
      print(
        'Google Sign In error: code: ${e.code.name} description:${e.description} details:${e.details}',
      );
      rethrow;
    } catch (error) {
      print('Unexpected Google Sign-In error: $error');
      rethrow;
    }
  }
}
