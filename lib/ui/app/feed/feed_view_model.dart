import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart' show GetIt;

import 'package:topix/data/models/post.dart';
import 'package:topix/data/services/post_service.dart';

class FeedViewModel extends ChangeNotifier {
  bool _loading = true;
  int _page = 0;
  bool _endOfList = false;
  final List<Post> _posts = [];

  final scroll = ScrollController();

  List<Post> get posts => _posts;

  bool get loading => _loading;

  Future<void> load() async {
    if (_endOfList) return;
    _loading = true;
    notifyListeners();
    _page++;
    final fetchResult = await GetIt.I<PostService>().getFeed(_page);
    _posts.addAll((fetchResult.$2).toList());
    _loading = false;
    _endOfList = fetchResult.$1;
    notifyListeners();
  }
}
