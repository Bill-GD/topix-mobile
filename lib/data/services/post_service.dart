import 'package:dio/dio.dart' show Dio, Options;

import 'package:topix/data/models/enums.dart';
import 'package:topix/data/models/post.dart' show PostModel;
import 'package:topix/data/services/token_service.dart';
import 'package:topix/utils/extensions.dart' show ParseApiResponse;

class PostService {
  final Dio _dio;
  final TokenService _tokenService;

  PostService({required Dio dio, required TokenService tokenService})
    : _tokenService = tokenService,
      _dio = dio;

  Future<(bool, Iterable<PostModel>)> getFeed(int page, [bool following = false]) async {
    final at = await _tokenService.tryGet(.access);
    final res = (await _dio.get(
      '/post${following ? '/following' : ''}?page=$page',
      options: Options(headers: {'Authorization': 'Bearer $at'}),
    )).toApiResponse();

    if (!res.success) throw Exception(res.error);
    final resData = res.data as List<dynamic>;
    return (
      bool.parse(res.headers['x-end-of-list']?.first ?? 'false'),
      resData.map((e) => PostModel.fromJson(e as Map<String, dynamic>)),
    );
  }

  Future<void> deletePost(int postId) async {
    final at = await _tokenService.tryGet(.access);
    final res = (await _dio.delete(
      '/post/$postId',
      options: Options(headers: {'Authorization': 'Bearer $at'}),
    )).toApiResponse();

    if (!res.success) throw Exception(res.error);
  }

  Future<void> react(int postId, ReactionType? type) async {
    final at = await _tokenService.tryGet(.access);
    if (type != null) {
      final res = (await _dio.patch(
        '/post/$postId/react',
        data: {'reaction': type.name},
        options: Options(headers: {'Authorization': 'Bearer $at'}),
      )).toApiResponse();
      if (!res.success) throw Exception(res.error);
    } else {
      final res = (await _dio.delete(
        '/post/$postId/react',
        options: Options(headers: {'Authorization': 'Bearer $at'}),
      )).toApiResponse();

      if (!res.success) throw Exception(res.error);
    }
  }
}
