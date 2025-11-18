import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart' show Dio;

import 'package:topix/utils/result.dart';

class LoginViewModel extends ChangeNotifier {
  final Dio dio;
  bool hidePassword = true;

  LoginViewModel({required this.dio});

  void togglePasswordVisibility() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  Future<Result> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return Result.fail('All fields must not be empty.');
    }

    final res = await dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );

    return Result.ok('Success', res.data);
  }
}
