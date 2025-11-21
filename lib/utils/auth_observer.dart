import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart' show GetIt;

import 'package:topix/data/services/auth_service.dart';
import 'package:topix/data/services/logger_service.dart';
import 'package:topix/data/services/token_service.dart';
import 'package:topix/ui/app/logged_in_route.dart';
import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart';
import 'package:topix/ui/auth/register/register_screen.dart';
import 'package:topix/ui/auth/verify/verify_screen.dart';

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
    final context = route.navigator!.context;
    final widget = route.builder(context);

    final [at, rt] = await Future.wait([
      tokenService.tryGet(.access),
      tokenService.tryGet(.refresh),
    ]);

    if (at == null && rt == null) {
      // blocks app access if no token present
      if (widget is! LoginScreen &&
          widget is! RegisterScreen &&
          widget is! VerifyScreen) {
        navigator?.pop();
        navigator?.pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen(viewModel: LoginViewModel());
            },
          ),
        );
      }
      return;
    }

    if (at == null) await GetIt.I<AuthService>().refresh();

    // blocks auth access if authenticated
    if (widget is LoginScreen || widget is RegisterScreen || widget is VerifyScreen) {
      LoggerService.log('AT & RT present, auth access is blocked');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return LoggedInRoute();
          },
        ),
      );
    }
  }
}
