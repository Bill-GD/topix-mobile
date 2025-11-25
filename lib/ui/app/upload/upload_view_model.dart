import 'package:flutter/material.dart';

class UploadViewModel extends ChangeNotifier {
  final int selfId;
  final int? parentPostId;

  UploadViewModel({required this.selfId, this.parentPostId});

  bool get isReply => parentPostId != null;
}
