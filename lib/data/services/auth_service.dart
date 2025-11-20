import 'package:dio/dio.dart' show Dio, Options;

import 'package:topix/data/services/logger_service.dart';
import 'package:topix/data/services/token_service.dart';
import 'package:topix/utils/extensions.dart' show ParseApiResponse;

class AuthService {
  final Dio _dio;
  final TokenService _tokenService;

  AuthService({required Dio dio, required TokenService tokenService})
    : _tokenService = tokenService,
      _dio = dio;

  Future<(bool, String)> register(String email, String username, String password) async {
    final res = (await _dio.post(
      '/auth/register',
      data: {
        'email': email,
        'username': username,
        'password': password,
        'confirmPassword': password, // already checked
      },
    )).toApiResponse();

    if (!res.success) return (false, '${res.error}');

    final resData = res.data as Map<String, dynamic>;
    return (true, '${resData['id']}');
  }

  Future<(bool, String)> verify(int userId, String otp) async {
    final res = (await _dio.post(
      '/auth/confirm/$userId',
      data: {'otp': otp},
    )).toApiResponse();

    if (!res.success) return (false, '${res.error}');
    return (true, res.message);
  }

  Future<(bool, String)> resend(int userId) async {
    final res = (await _dio.post('/auth/resend/$userId')).toApiResponse();

    if (!res.success) return (false, '${res.error}');
    return (true, 'The code has been resent. Please check your email.');
  }

  Future<void> refresh() async {
    final res = (await _dio.post(
      '/auth/refresh',
      options: Options(headers: {'Authorization': _tokenService.tryGet(.refresh)}),
    )).toApiResponse();

    final resData = res.data as Map<String, dynamic>;

    await _tokenService.writeToken(.access, resData['token'], resData['time'] as int);
    LoggerService.log('Access token refreshed');
  }

  Future<(bool, String)> login(String username, String password) async {
    final res = (await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    )).toApiResponse();

    if (!res.success) return (false, res.message);

    final resData = res.data as Map<String, dynamic>;

    await _tokenService.writeToken(
      .access,
      resData['accessToken'],
      resData['atTime'] as int,
    );
    await _tokenService.writeToken(
      .refresh,
      resData['refreshToken'],
      resData['rtTime'] as int,
    );

    return (true, res.message);
  }
}
