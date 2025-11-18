import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart' show Dio;

import 'package:topix/utils/api_response.dart';
import 'package:topix/utils/extensions.dart';

class LoginViewModel extends ChangeNotifier {
  final Dio dio;
  bool hidePassword = true;

  LoginViewModel({required this.dio});

  void togglePasswordVisibility() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  Future<ApiResponse> login(String username, String password) async {
    final res = await dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    return res.toApiResponse();
  }
}
