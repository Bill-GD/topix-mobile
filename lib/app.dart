import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
import 'package:topix/ui/core/widget_error_screen.dart';
import 'package:topix/utils/auth_observer.dart';

class TopixApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const TopixApp({super.key, required this.navKey});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      defaultThemeId:
          '${SchedulerBinding.instance.platformDispatcher.platformBrightness.name}_theme',
      themes: [
        AppTheme(
          id: 'light_theme',
          description: 'Light theme',
          data: ThemeData(
            useMaterial3: true,
            fontFamily: 'Nunito',
            brightness: .light,
            // sliderTheme: const SliderThemeData(
            //   activeTickMarkColor: Colors.transparent,
            //   inactiveTickMarkColor: Colors.transparent,
            // ),
            colorScheme: .fromSeed(seedColor: Colors.blueAccent, brightness: .light),
          ),
        ),
        AppTheme(
          id: 'dark_theme',
          description: 'Dark theme',
          data: ThemeData(
            useMaterial3: true,
            fontFamily: 'Nunito',
            brightness: .dark,
            // sliderTheme: const SliderThemeData(
            //   activeTickMarkColor: Colors.transparent,
            //   inactiveTickMarkColor: Colors.transparent,
            // ),
            colorScheme: .fromSeed(seedColor: Colors.blueAccent, brightness: .dark),
          ),
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              navigatorKey: navKey,
              title: 'Flutter Demo',
              theme: ThemeProvider.themeOf(context).data,
              debugShowCheckedModeBanner: false,
              navigatorObservers: [AuthObserver()],
              builder: (context, child) {
                ErrorWidget.builder = (errorDetails) {
                  return WidgetErrorScreen(e: errorDetails);
                };
                if (child != null) return child;
                throw StateError('Widget is null');
              },
              home: LoginScreen(viewModel: LoginViewModel(dio: context.read())),
            );
          },
        ),
      ),
    );
  }
}
