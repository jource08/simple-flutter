import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _errorMessage = '';

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  String get errorMessage => _errorMessage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  set email(String value) {
    _email = value;
    _emailController.text = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    _passwordController.text = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> doLogin(
      BuildContext context, String email, String password) async {
    Dio dio = Dio();

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Response<dynamic> loginResponse =
          await dio.post(AppConst.loginUrl, data: {
        "email": email,
        "password": password,
      });

      // Dismiss any existing Snackbar before showing new one
      ScaffoldMessenger.of(context).clearSnackBars();

      // Check if login was successful by examining the response structure
      if (loginResponse.data['message'] == 'Login successful') {
        var userData = loginResponse.data['data'][0];

        String? cookie = loginResponse.headers['set-cookie']?.firstWhere(
          (header) => header.startsWith('NODEJS-API-AUTH'),
          orElse: () => '',
        );

        User user = User(
          id: userData["id"],
          username: userData["username"],
          email: userData["email"],
          fullname: userData["fullname"],
          bio: userData["bio"],
          profileImageUrl: userData["profile_image_url"],
        );

        String mydata = jsonEncode({
          AppConst.userPrefKey: user.toJson(),
          AppConst.cookiePrefKey: cookie,
        });

        prefs.setString(AppConst.loginSessionPrefKey, mydata);

        Provider.of<SessionProvider>(context, listen: false).setUser(user);
        Provider.of<SessionProvider>(context, listen: false).setAuthCookie("$cookie");

        // Show success message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful!"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the main screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainScreen()));
      } else {
        _errorMessage = 'Login failed: ${loginResponse.data['message']}';
        notifyListeners();

        // Show error message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
      _errorMessage = 'Login failed: ${e.response?.data["message"] ?? e.message}';
      notifyListeners();

      // Show error message in Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();

      // Show error message in Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
