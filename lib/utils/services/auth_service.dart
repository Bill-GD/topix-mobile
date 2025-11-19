import 'package:flutter/material.dart';

import 'package:dio/dio.dart' show Dio, Options;
import 'package:get_it/get_it.dart';

import 'package:topix/utils/extensions.dart' show ParseApiResponse;
import 'package:topix/utils/services/logger_service.dart';
import 'package:topix/utils/services/token_service.dart';

class AuthService extends ChangeNotifier {
  final Dio dio;

  AuthService({required this.dio});

  Future<void> refresh() async {
    final tokenService = GetIt.I<TokenService>();
    final res = (await dio.post(
      '/auth/refresh',
      options: Options(headers: {'Authorization': tokenService.tryGet(.refresh)}),
    )).toApiResponse();

    final resData = res.data as Map<String, dynamic>;

    await tokenService.writeToken(
      .access,
      resData['token'],
      resData['time'] as int,
    );
    LoggerService.log('Access token refreshed');
  }
}
