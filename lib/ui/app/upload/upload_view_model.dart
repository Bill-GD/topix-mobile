import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:topix/data/services/post_service.dart';

class UploadViewModel extends ChangeNotifier {
  final int selfId;
  final int? parentPostId;
  final bool allowVisiblity;

  final images = <String>[];
  String? video;

  UploadViewModel({required this.selfId, this.parentPostId, this.allowVisiblity = false});

  bool get isReply => parentPostId != null;

  bool get hasImage => images.isNotEmpty;

  bool get hasVideo => video != null;

  Future<bool> uploadPost(String content) {
    final postService = GetIt.I<PostService>();
    return isReply
        ? postService.reply(parentPostId!, content)
        : postService.uploadPost(content);
  }

  void addImage(String path) {
    images.add(path);
    notifyListeners();
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  void updateVideo(String path) {
    video = path;
    notifyListeners();
  }

  void removeVideo() {
    video = null;
    notifyListeners();
  }
}
