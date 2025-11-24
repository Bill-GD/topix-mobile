import 'package:flutter/cupertino.dart';

import 'package:get_it/get_it.dart';

import 'package:topix/data/models/user.dart';
import 'package:topix/data/services/user_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  bool _loadingUser = true;
  final String _username;
  late final UserModel _user;

  UserProfileViewModel({required String username}) : _username = username;

  UserModel get user => _user;

  bool get loadingUser => _loadingUser;

  void loadUser() async {
    _user = await GetIt.I<UserService>().getUser(_username);
    _loadingUser = false;
    notifyListeners();
  }
}
