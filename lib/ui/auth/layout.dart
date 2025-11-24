import 'package:flutter/material.dart';

import 'package:theme_provider/theme_provider.dart' show ThemeProvider;

import 'package:topix/utils/extensions.dart' show ThemeHelper;

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PositionedDirectional(
              top: 4,
              end: 4,
              child: IconButton(
                onPressed: ThemeProvider.controllerOf(context).nextTheme,
                icon: Icon(
                  context.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
