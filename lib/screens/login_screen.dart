import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/screens/forgot_password_screen.dart';

import 'package:myapp/screens/main_screen.dart';
import 'package:myapp/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo-home.png"),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    label: Text("Username"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    // suffixIcon: IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(Icons.visibility),
                    // ),
                    label: Text("Password"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen()));
                    },
                    child: const Text("Forgot password ?")),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppConst.colorPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      String username = usernameController.text.trim();
                      String password = passwordController.text.trim();
                      if (username.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        doLogin(context, username, password);
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()));
                        },
                        child: const Text("Register")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
void doLogin(BuildContext context, String username, String password) async {
  Dio dio = Dio();

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response<dynamic> loginResponse = await dio.post(AppConst.loginUrl, data: {
      "email": username,
      "password": password,
    });

    // Extract cookie from the headers
    String? cookie = loginResponse.headers['set-cookie']?.firstWhere(
      (header) => header.startsWith('NODEJS-API-AUTH'),
      orElse: () => '',
    );

    // Assuming the response contains a list of users, extract the first user
    var dataList = loginResponse.data;
    if (dataList is List && dataList.isNotEmpty && cookie != null && cookie.isNotEmpty) {
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
      Provider.of<SessionProvider>(context, listen: false).setAuthCookie(cookie);

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
