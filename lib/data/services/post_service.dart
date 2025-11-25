import 'package:dio/dio.dart' show Dio, Options, Headers, FormData;

import 'package:topix/data/models/enums.dart';
import 'package:topix/data/models/post.dart' show PostModel;
import 'package:topix/data/services/logger_service.dart';
import 'package:topix/data/services/token_service.dart';
import 'package:topix/utils/extensions.dart' show ParseApiResponse;

class PostService {
  final Dio _dio;
  final TokenService _tokenService;

  PostService({required Dio dio, required TokenService tokenService})
    : _tokenService = tokenService,
      _dio = dio;

  Future<bool> uploadPost(String content) async {
    LoggerService.log('Uploading new post');
    final at = await _tokenService.tryGet(.access);

    final res = (await _dio.post(
      '/post',
      data: FormData.fromMap({
        'content': content,
        'type': 'image',
        'approved': true,
      }),
      options: Options(
        headers: {
          'Authorization': 'Bearer $at',
          Headers.contentTypeHeader: Headers.multipartFormDataContentType,
        },
      ),
    )).toApiResponse();

    if (!res.success) throw Exception(res.error);
    return true;
  }

  Future<(bool, Iterable<PostModel>)> getFeed(int page, [bool following = false]) async {
    LoggerService.log('Fetching ${following ? 'following ' : ''}feed, page $page');

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

  Future<(bool, Iterable<PostModel>)> getUserPosts({
    required int selfId,
    required int userId,
    required int page,
  }) async {
    LoggerService.log('Fetching posts of user #$userId, page $page');

    final at = await _tokenService.tryGet(.access);
    final res = (await _dio.get(
      '/post?userId=$userId${selfId == userId ? '&visibility=private' : ''}&page=$page&threadId=null&groupId=null',
      options: Options(headers: {'Authorization': 'Bearer $at'}),
    )).toApiResponse();

    if (!res.success) throw Exception(res.error);
    final resData = res.data as List<dynamic>;
    return (
      bool.parse(res.headers['x-end-of-list']?.first ?? 'false'),
      resData.map((e) => PostModel.fromJson(e as Map<String, dynamic>)),
    );
  }

  Future<(bool, Iterable<PostModel>)> getPostReplies({
    required int postId,
    int? threadId,
    int? groupId,
    required int page,
  }) async {
    LoggerService.log('Fetching replies of post #$postId, page $page');

    final at = await _tokenService.tryGet(.access);
    final res = (await _dio.get(
      '/post?parentId=$postId&page=$page'
      '${groupId != null ? '&groupId=$groupId' : ''}'
      '${threadId != null ? '&threadId=$threadId' : ''}',
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
