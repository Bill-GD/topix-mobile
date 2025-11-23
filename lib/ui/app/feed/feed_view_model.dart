import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart' show GetIt;

import 'package:topix/data/models/post.dart';
import 'package:topix/data/services/post_service.dart';

enum FeedType { all, following }

class FeedViewModel extends ChangeNotifier {
  bool _loading = true;
  int _newPage = 0, _followPage = 0;
  bool _newEndOfList = false, _followEndOfList = false;

  final _newPosts = <Post>[], _followingPosts = <Post>[];

  final scroll = ScrollController();

  List<Post> posts(FeedType type) {
    return switch (type) {
      .all => _newPosts,
      .following => _followingPosts,
    };
  }

  bool get loading => _loading;

  Future<void> loadNew({bool reload = false}) async {
    if (_newEndOfList) return;
    if (reload) {
      _newPage = 0;
      _newPosts.clear();
    }

    _loading = true;
    notifyListeners();

    _newPage++;
    final fetchResult = await GetIt.I<PostService>().getFeed(_newPage);

    _newPosts.addAll((fetchResult.$2).toList());
    _loading = false;
    _newEndOfList = fetchResult.$1;
    notifyListeners();
  }

  Future<void> loadFollowing({bool reload = false}) async {
    if (_followEndOfList) return;
    if (reload) {
      _followPage = 0;
      _followingPosts.clear();
    }

    _loading = true;
    notifyListeners();

    _followPage++;
    final fetchResult = await GetIt.I<PostService>().getFeed(_followPage, true);

    _followingPosts.addAll((fetchResult.$2).toList());
    _loading = false;
    _followEndOfList = fetchResult.$1;
    notifyListeners();
  }
}
