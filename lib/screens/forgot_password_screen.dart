// Suggested code may be subject to a license. Learn more: ~LicenseLog:2527159535.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1623168734.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2153736940.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:517167100.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3471127712.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:379432333.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:100099515.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3897818102.
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implement password reset logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password reset email sent!')),
                    );
                  }
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
