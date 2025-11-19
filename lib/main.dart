import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:topix/app.dart';
import 'package:topix/firebase_options.dart';
import 'package:topix/ui/core/popup.dart' show showPopupMessage;
import 'package:topix/utils/constants.dart' show Constants;
import 'package:topix/utils/helpers.dart' show setupFirebaseRemoteConfig;
import 'package:topix/utils/services/auth_service.dart';
import 'package:topix/utils/services/token_service.dart' show TokenService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  PlatformDispatcher.instance.onError = (e, s) {
    final curContext = navigatorKey.currentContext;
    if (curContext == null) return false;

    showPopupMessage(
      curContext,
      title: e.toString(),
      content: s.toString(),
      centerContent: false,
    );
    return true;
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final remoteConfig = FirebaseRemoteConfig.instance;
  await setupFirebaseRemoteConfig(remoteConfig);

  GetIt.I.registerSingleton(TokenService(FlutterSecureStorage()));
  GetIt.I.registerSingleton(
    Dio(
      BaseOptions(
        baseUrl: Constants.apiUrl.value,
        contentType: Headers.jsonContentType,
        headers: {Headers.acceptHeader: Headers.jsonContentType},
        validateStatus: (_) {
          return true;
        },
      ),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: remoteConfig),
        Provider.value(value: GetIt.I<Dio>()),
        Provider(create: (_) => AuthService(dio: GetIt.I<Dio>())),
      ],
      child: TopixApp(navKey: navigatorKey),
    ),
  );
}
