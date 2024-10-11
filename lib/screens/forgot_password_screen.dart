import 'package:flutter/material.dart';
import 'package:myapp/providers/forgot_password_provider.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
      child: Consumer<ForgotPasswordProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(title: const Text('Forgot Password')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Email Input
                  provider.isOtpSent ? Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: provider.isLoading || provider.isOtpSent
                            ? null
                            : () {
                                provider.sendOtp(context, emailController.text);
                              },
                        child: provider.isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Send OTP'),
                      ),
                    ],
                  ) : const SizedBox(),
                  const SizedBox(height: 16),
                  // OTP Input
                  if (provider.isOtpSent)
                    Column(
                      children: [
                        TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            labelText: 'Enter OTP',
                            hintText: provider.otp ?? "",
                            hintStyle: const TextStyle(color: Colors.black38),
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: provider.isLoading || provider.isOtpValid
                              ? null
                              : () {
                                  provider.verifyOtp(
                                      context, otpController.text);
                                },
                          child: provider.isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Verify OTP'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // Password Reset Inputs
                  if (provider.isOtpValid)
                    Column(
                      children: [
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          onChanged: (value) {
                            provider.validatePassword(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          onChanged: (value) {
                            provider.validatePassword(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Confirm New Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              provider.isLoading || !provider.isPasswordValid
                                  ? null
                                  : () async {
                                      await provider.resetPassword(
                                        context,
                                        provider.email!,
                                        provider.otp!,
                                        passwordController.text,
                                      );
                                    },
                          child: provider.isLoading || confirmPasswordController.text == passwordController.text
                              ? const CircularProgressIndicator()
                              : const Text('Reset Password'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
