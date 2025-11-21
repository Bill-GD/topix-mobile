import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart' show BaseOptions, Dio, Headers;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;

import 'package:topix/app.dart';
import 'package:topix/data/services/auth_service.dart';
import 'package:topix/data/services/logger_service.dart';
import 'package:topix/data/services/token_service.dart' show TokenService;
import 'package:topix/data/services/user_service.dart';
import 'package:topix/firebase_options.dart';
import 'package:topix/ui/core/widgets/popup.dart' show showPopupMessage;
import 'package:topix/utils/constants.dart';
import 'package:topix/utils/helpers.dart' show setupFirebaseRemoteConfig;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (e, s) {
    final curContext = navigatorKey.currentContext;
    if (curContext == null) return false;

    LoggerService.log(
      '${e.toString()}\n'
      'Stack:\n'
      '\n${s.toString()}',
      .error,
    );

    showPopupMessage(
      curContext,
      title: e.toString(),
      content: s.toString(),
      centerContent: false,
    );
    return true;
  };

  await dotenv.load();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final remoteConfig = FirebaseRemoteConfig.instance;
  await setupFirebaseRemoteConfig(remoteConfig);

  await GoogleSignIn.instance.initialize();

  GetIt.I.registerSingleton(TokenService(FlutterSecureStorage()));
  GetIt.I.registerSingleton(GoogleSignIn.instance);
  GetIt.I.registerSingleton(
    Dio(
      BaseOptions(
        baseUrl: Constants.apiUrl.value,
        contentType: Headers.jsonContentType,
        headers: {Headers.acceptHeader: Headers.jsonContentType},
        validateStatus: (_) => true,
      ),
    ),
  );
  GetIt.I.registerSingleton(
    AuthService(dio: GetIt.I<Dio>(), tokenService: GetIt.I<TokenService>()),
  );
  GetIt.I.registerSingleton(
    UserService(dio: GetIt.I<Dio>(), tokenService: GetIt.I<TokenService>()),
  );

  runApp(TopixApp(navKey: navigatorKey));
}
