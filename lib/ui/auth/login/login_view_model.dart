import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart' show Dio;
import 'package:get_it/get_it.dart' show GetIt;

import 'package:topix/utils/extensions.dart' show ParseApiResponse;
import 'package:topix/utils/models/api_response.dart';
import 'package:topix/utils/services/token_service.dart';

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

  Future<void> saveTokens(Map<String, dynamic> resData) async {
    final tokenService = GetIt.I<TokenService>();
    await tokenService.writeToken(
      .access,
      resData['accessToken'],
      resData['atTime'] as int,
    );
    await tokenService.writeToken(
      .refresh,
      resData['refreshToken'],
      resData['rtTime'] as int,
    );
  }

  Future<String?> tryGetToken(TokenType type) async {
    return GetIt.I<TokenService>().tryGet(type);
  }
}
