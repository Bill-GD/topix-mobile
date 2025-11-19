import 'package:flutter/foundation.dart';

class VerifyViewModel extends ChangeNotifier {
  final int _userId;

  VerifyViewModel({required int userId}) : _userId = userId;

  int get userId => _userId;
}
