import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/screens/login_screen.dart';

class ForgotPasswordProvider with ChangeNotifier {
  String? _email;
  String? _otp;
  String? _newPassword;
  bool _isEmailValid = false;
  bool _isOtpValid = false;
  bool _isPasswordValid = false;
  bool _isLoading = false;
  bool _isOtpSent = false;

  String? get email => _email;
  String? get otp => _otp;
  String? get newPassword => _newPassword;
  bool get isEmailValid => _isEmailValid;
  bool get isOtpValid => _isOtpValid;
  bool get isPasswordValid => _isPasswordValid;
  bool get isLoading => _isLoading;
  bool get isOtpSent => _isOtpSent;

  void sendOtp(BuildContext context, String email) async {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    _email = email;
    try {
      Response response = await Dio().post(
        AppConst.forgotPasswordUrl,
        data: {'email': email},
      );
      if (response.statusCode == 200) {
        _isEmailValid = true;
        _otp = response.data['demo_otp'];
        _isOtpSent = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Enter demo OTP: $_otp')));
      } else {
        _isEmailValid = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.data['message'] ?? 'Error sending OTP'),
          backgroundColor: Colors.red,
        ));
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      String errorMessage = 'Unknown error occurred';
      if (e is DioException) {
        errorMessage =
            e.response?.data["message"] ?? e.message ?? 'Error occurred';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $errorMessage'),
        backgroundColor: Colors.red,
      ));
      _isLoading = false;
      notifyListeners();
    }
  }

  void verifyOtp(BuildContext context, String otp) async {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    _isOtpValid = _otp == otp;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isOtpValid ? "OTP verified" : "Invalid OTP"),
      backgroundColor: _isOtpValid ? Colors.green : Colors.red,
    ));
    _isLoading = false;
    notifyListeners();
  }

  void validatePassword(String password) {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    final regex =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$');
    if (regex.hasMatch(password)) {
      _isPasswordValid = true;
      _newPassword = password;
    } else {
      _isPasswordValid = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context, String email, String otp,
      String newPassword) async {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      Response response = await Dio().post(
        AppConst.resetPasswordUrl,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password reset successfully'),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.data['message'] ?? 'Password reset failed'),
          backgroundColor: Colors.red,
        ));
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      String errorMessage = 'Unknown error occurred';
      if (e is DioException) {
        errorMessage =
            e.response?.data["message"] ?? e.message ?? 'Error occurred';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $errorMessage'),
        backgroundColor: Colors.red,
      ));
      _isLoading = false;
      notifyListeners();
    }
  }
}
