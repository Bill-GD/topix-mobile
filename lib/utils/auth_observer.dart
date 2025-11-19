import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';

import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart';
import 'package:topix/ui/auth/register/register_screen.dart';
import 'package:topix/utils/services/auth_service.dart';
import 'package:topix/utils/services/logger_service.dart';
import 'package:topix/utils/services/token_service.dart';

class AuthObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _handleCheck(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _handleCheck(newRoute);
  }

  Future<void> _handleCheck(Route? route) async {
    if (route == null || route is! MaterialPageRoute) return;

    final tokenService = GetIt.I<TokenService>();
    final widget = route.builder(route.navigator!.context);

    final [at, rt] = await Future.wait([
      tokenService.tryGet(.access),
      tokenService.tryGet(.refresh),
    ]);

    if (at == null && rt == null) {
      // blocks app access if no token present
      if (widget is! LoginScreen && widget is! RegisterScreen) {
        navigator?.pop();
        navigator?.pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen(viewModel: LoginViewModel(dio: context.read()));
            },
          ),
        );
      }
      return;
    }

    if (at == null) {
      final authService = AuthService(dio: route.navigator!.context.read());
      await authService.refresh();
    }

    // blocks auth access if authenticated
    if (widget is LoginScreen || widget is RegisterScreen) {
      // TODO redirect to home
      LoggerService.log('to home');
    }
  }
}
