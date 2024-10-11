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
    Response<dynamic> loginResponse = await dio.post(AppConst.loginUrl, data: {
      "username": username,
      "password": password,
    });

    if (loginResponse.statusCode == 200) {
      // Fetch user details
      Response<dynamic> userDetailResponse = await dio.get(
        "${AppConst.listUserUrl}?user_name=${loginResponse.data["username"]}",
        options: Options(
          method: 'GET',
        ),
      );

      User user = User(
        id: userDetailResponse.data["id"],
        username: userDetailResponse.data["username"],
        email: userDetailResponse.data["email"],
        fullname: userDetailResponse.data["fullname"],
        bio: userDetailResponse.data["bio"],
        profileImageUrl: userDetailResponse.data["profile_image_url"],
      );

      // Save to SharedPreferences
      String mydata = jsonEncode({
        AppConst.userPrefKey: user.toJson(),
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(AppConst.loginSessionPrefKey, mydata);

      Provider.of<SessionProvider>(context, listen: false).setUser(user);

      // Show success snackbar
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
      // Show error snackbar for failed login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: ${loginResponse.statusMessage}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } on DioException catch (e) {
    debugPrint(e.toString());
    // Show error snackbar for Dio exceptions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        // content: Text("Error: ${e.message}"),
        content: Text("Error: Login failed"),
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
