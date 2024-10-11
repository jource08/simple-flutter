import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/providers/registration_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController =
      TextEditingController(); // Password confirmation
  final _fullnameController = TextEditingController();
  final _bioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const CircleAvatar(
                    radius: 60,
                    backgroundColor: AppConst.colorSecondary,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      // TODO: Implement gallery image picker
                                    },
                                    child: const ListTile(
                                      leading: Icon(Icons.image),
                                      title: Text("From gallery"),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // TODO: Implement camera image picker
                                    },
                                    child: const ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text("From camera"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: const Text("Add profile picture"),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'si_udin123',
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // Regular expression to allow alphanumeric, underscores and can start with a number.
                    final usernameRegExp = RegExp(r'^[A-Za-z0-9_]+$');
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    } else if (!usernameRegExp.hasMatch(value)) {
                      return 'Username can only contain letters, numbers, and underscores';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'si_udin123@gmail.com',
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'alphanumeric, lower and upper case, and a symbol.',
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (!RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$')
                        .hasMatch(value)) {
                      return 'Password must be at least 8 characters,\ninclude upper and lower case letters, a number, and a symbol';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _fullnameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    prefixIcon: Icon(Icons.info),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32.0),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppConst.colorPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Consumer<RegistrationProvider>(
                    builder: (context, provider, _) {
                      return TextButton(
                        onPressed: provider.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  provider.registerUser(
                                    context,
                                    _usernameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    _fullnameController.text,
                                    _bioController.text,
                                  );
                                }
                              },
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
