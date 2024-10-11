import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/screens/login_screen.dart';

class RegistrationProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> registerUser(
    BuildContext context,
    String username,
    String email,
    String password,
    String fullname,
    String bio,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final dio = Dio();
      final response = await dio.post(
        AppConst.registerUrl,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'fullname': fullname,
          'bio': bio.isNotEmpty ? bio : null,
          'profile_image_url': null,
        },
      );

      if (response.statusCode == 200) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage)));
      }
    } catch (error) {
      _errorMessage = 'Failed to register: $error';
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_errorMessage)));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
