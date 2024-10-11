import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> doLogin(
      BuildContext context, String email, String password) async {
    Dio dio = Dio();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Response<dynamic> loginResponse =
          await dio.post(AppConst.loginUrl, data: {
        "email": email,
        "password": password,
      });

      // Extract cookie from the headers
      String? cookie = loginResponse.headers['set-cookie']?.firstWhere(
        (header) => header.startsWith('NODEJS-API-AUTH'),
        orElse: () => '',
      );

      // Assuming the response contains a list of users, extract the first user
      var dataList = loginResponse.data;
      if (dataList is List &&
          dataList.isNotEmpty &&
          cookie != null &&
          cookie.isNotEmpty) {
        var userData = dataList[0]; // Extract the first user from the list

        User user = User(
          id: userData["id"],
          username: userData["username"],
          email: userData["email"],
          fullname: userData["fullname"],
          bio: userData["bio"],
          profileImageUrl: userData["profile_image_url"],
        );

        // Save user data to SharedPreferences
        String mydata = jsonEncode({
          AppConst.userPrefKey: user.toJson(),
          AppConst.cookiePrefKey: cookie,
        });
        prefs.setString(AppConst.loginSessionPrefKey, mydata);

        Provider.of<SessionProvider>(context, listen: false).setUser(user);
        Provider.of<SessionProvider>(context, listen: false)
            .setAuthCookie(cookie);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful!"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the Main Screen after successful login
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainScreen()));
      } else {
        // If the response doesn't contain a valid user list, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid login response"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
      // Show error snackbar for Dio exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: ${e.response?.data ?? e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Show generic error snackbar for other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
