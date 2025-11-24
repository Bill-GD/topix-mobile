import 'package:dio/dio.dart' show Dio, Options;

import 'package:topix/data/models/user.dart';
import 'package:topix/data/services/logger_service.dart';
import 'package:topix/data/services/token_service.dart';
import 'package:topix/utils/extensions.dart' show ParseApiResponse;

class UserService {
  final Dio _dio;
  final TokenService _tokenService;

  UserService({required Dio dio, required TokenService tokenService})
    : _tokenService = tokenService,
      _dio = dio;

  Future<UserModel> getSelf() async {
    LoggerService.log('Fetching current user');
    final at = await _tokenService.tryGet(.access);
    final res = (await _dio.get(
      '/user/me',
      options: Options(headers: {'Authorization': 'Bearer $at'}),
    )).toApiResponse();

    if (!res.success) throw Exception(res.error);
    return UserModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<UserModel> getUser(String username) async {
    LoggerService.log('Fetching user @$username');
    final at = await _tokenService.tryGet(.access);
    final res = (await _dio.get(
      '/user/$username',
      options: Options(headers: {'Authorization': 'Bearer $at'}),
    )).toApiResponse();

    if (!res.success) throw Exception(res.error);
    return UserModel.fromJson(res.data as Map<String, dynamic>);
  }
}
