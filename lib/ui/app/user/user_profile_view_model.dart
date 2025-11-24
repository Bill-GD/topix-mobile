import 'package:flutter/cupertino.dart';

import 'package:get_it/get_it.dart';

import 'package:topix/data/models/enums.dart' show ReactionType;
import 'package:topix/data/models/post.dart';
import 'package:topix/data/models/user.dart';
import 'package:topix/data/services/post_service.dart';
import 'package:topix/data/services/user_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final String _username;

  bool _loadingUser = true, _loadingPosts = false;
  int _postPage = 0;
  bool _postEndOfList = false;
  final _posts = <PostModel>[];
  final postScroll = ScrollController();

  late final UserModel _user;

  UserProfileViewModel({required String username}) : _username = username;

  UserModel get user => _user;

  bool get loadingUser => _loadingUser;

  bool get loadingPosts => _loadingPosts;

  List<PostModel> get posts => _posts;

  Future<void> loadUser() async {
    _user = await GetIt.I<UserService>().getUser(_username);
    _loadingUser = false;
    notifyListeners();
  }

  void loadPosts(int selfId) async {
    if (_loadingPosts || _postEndOfList) return;
    _loadingPosts = true;
    notifyListeners();

    _postPage++;
    final fetchResult = await GetIt.I<PostService>().getUserPosts(
      selfId: selfId,
      userId: _user.id,
      page: _postPage,
    );

    _posts.addAll((fetchResult.$2).toList());
    _loadingPosts = false;
    _postEndOfList = fetchResult.$1;
    notifyListeners();
  }

  Future<void> removePost(int postId) async {
    _posts.removeWhere((p) => p.id == postId);
    await GetIt.I<PostService>().deletePost(postId);
    notifyListeners();
  }

  Future<void> reactPost(int postId, ReactionType? type) async {
    await GetIt.I<PostService>().react(postId, type);
    notifyListeners();
  }
}
