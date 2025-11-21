import 'package:dio/dio.dart' show Dio, Options;

import 'package:topix/data/models/post.dart' show Post;
import 'package:topix/data/services/token_service.dart';
import 'package:topix/utils/extensions.dart' show ParseApiResponse;

class PostService {
  final Dio _dio;
  final TokenService _tokenService;

  PostService({required Dio dio, required TokenService tokenService})
    : _tokenService = tokenService,
      _dio = dio;

  Future<(bool, Iterable<Post>)> getFeed(int page) async {
    final at = await _tokenService.tryGet(.access);
    final res = (await _dio.get(
      '/post?page=$page',
      options: Options(headers: {'Authorization': 'Bearer $at'}),
    )).toApiResponse();

    if (!res.success) throw Exception(res.error);
    final resData = res.data as List<dynamic>;
    return (
      bool.parse(res.headers['x-end-of-list']?.first ?? 'false'),
      resData.map((e) => Post.fromJson(e as Map<String, dynamic>)),
    );
  }
}
