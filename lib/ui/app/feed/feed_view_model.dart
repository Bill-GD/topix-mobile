import 'package:flutter/foundation.dart';

class FeedViewModel extends ChangeNotifier {
  Future<void> load() async {
    notifyListeners();
  }
}
