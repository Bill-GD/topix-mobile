import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:provider/provider.dart';

import 'package:topix/app.dart';
import 'package:topix/firebase_options.dart';
import 'package:topix/ui/core/popup.dart';
import 'package:topix/utils/constants.dart';
import 'package:topix/utils/helpers.dart';

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

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: remoteConfig),
        Provider(
          create: (_) => Dio(
            BaseOptions(
              baseUrl: Constants.apiUrl.value,
              contentType: Headers.jsonContentType,
              headers: {Headers.acceptHeader: Headers.jsonContentType},
              validateStatus: (_) {
                return true;
              }
            ),
          ),
        ),
      ],
      child: TopixApp(navKey: navigatorKey),
    ),
  );
}
