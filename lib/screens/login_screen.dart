import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/screens/forgot_password_screen.dart';

import 'package:myapp/screens/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final sessionProvider = Provider.of<SessionProvider>(context);
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
                       sessionProvider.doLogin(context, username, password);
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