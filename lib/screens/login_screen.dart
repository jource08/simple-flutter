import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/providers/login_provider.dart';
import 'package:myapp/screens/forgot_password_screen.dart';
import 'package:myapp/screens/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    // Get the email and password controllers from the provider
    final TextEditingController emailController = loginProvider.emailController;
    final TextEditingController passwordController = loginProvider.passwordController;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo-home.png"),
                const SizedBox(height: 16),
                // Email text field
                TextField(
                  controller: emailController,
                  enabled: !loginProvider.isLoading,
                  onChanged: (value) => loginProvider.email = value,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    label: Text("Email"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Password text field with visibility toggle
                TextField(
                  controller: passwordController,
                  obscureText: !loginProvider.isPasswordVisible,
                  enabled: !loginProvider.isLoading,
                  onChanged: (value) => loginProvider.password = value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    label: const Text("Password"),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginProvider.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        loginProvider.togglePasswordVisibility();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Forgot password button
                TextButton(
                  onPressed: loginProvider.isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                  child: const Text("Forgot password ?"),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppConst.colorPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: loginProvider.isLoading
                        ? null
                        : () async {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            String username = emailController.text.trim();
                            String password = passwordController.text.trim();
                            if (username.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              await loginProvider.doLogin(
                                  context, username, password);
                            }
                          },
                    child: loginProvider.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Don't have an account text and Register button
                Row(
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: loginProvider.isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegisterScreen(),
                                ),
                              );
                            },
                      child: const Text("Register"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
