import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/models/user_model.dart';
import 'package:provider/provider.dart';

class ProfileEditProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> updateProfile(
      BuildContext context, User user, String name, String bio) async {
    setLoading(true);

    final dio = Dio();
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    String authCookie = sessionProvider.authCookie;
    try {
      final updatedUser = {
        'username': user.username,
        'email': user.email,
        'fullname': name,
        'bio': bio,
        'profile_image_url': user.profileImageUrl,
      };

      final response = await dio.put(
        "${AppConst.listUserUrl}/${user.id}",
        data: updatedUser,
        options: Options(
          headers: {
            'Cookie': authCookie,
          },
        ),
      );

      if (response.statusCode == 200) {
        // Successfully updated the profile on the server, now update locally
        sessionProvider.setUser(user.copyWith(fullname: name, bio: bio));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to update profile"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred"),
        backgroundColor: Colors.red,
      ));
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
