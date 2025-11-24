import 'package:flutter/cupertino.dart';

import 'package:get_it/get_it.dart';

import 'package:topix/data/models/enums.dart' show ReactionType;
import 'package:topix/data/models/post.dart';
import 'package:topix/data/services/post_service.dart';

class PostViewModel extends ChangeNotifier {
  final PostModel _post;

  bool _loading = false;
  int _replyPage = 0;
  bool _endOfList = false;
  final _replies = <PostModel>[];
  final scroll = ScrollController();

  PostViewModel({required PostModel post}) : _post = post;

  bool get loading => _loading;

  PostModel get post => _post;

  List<PostModel> get replies => _replies;

  void loadReplies() async {
    if (_loading || _endOfList) return;
    _loading = true;
    notifyListeners();

    _replyPage++;
    final fetchResult = await GetIt.I<PostService>().getPostReplies(
      postId: _post.id,
      page: _replyPage,
    );

    _replies.addAll((fetchResult.$2).toList());
    _loading = false;
    _endOfList = fetchResult.$1;
    notifyListeners();
  }

  Future<void> removePost(int postId) async {
    _replies.removeWhere((p) => p.id == postId);
    await GetIt.I<PostService>().deletePost(postId);
    notifyListeners();
  }

  Future<void> reactPost(int postId, ReactionType? type) async {
    await GetIt.I<PostService>().react(postId, type);
    notifyListeners();
  }
}
