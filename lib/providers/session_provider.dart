import 'package:flutter/material.dart';
import 'package:myapp/models/user_model.dart';

class SessionProvider with ChangeNotifier {
  User _user = User(
    id: 0,
    username: "",
    email: "",
    fullname: "",
    bio: "",
    profileImageUrl: "",
  );

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  String _authCookie = "";
  String get authCookie => _authCookie;

  void setAuthCookie(String authCookie) {
    _authCookie = authCookie;
    notifyListeners();
  }

}
