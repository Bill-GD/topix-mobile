import 'dart:ui';

import 'package:flutter/material.dart';

import 'app.dart';
import 'ui/core/ui_helpers.dart';

void main() {
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
  runApp(TopixApp(navKey: navigatorKey));
}
