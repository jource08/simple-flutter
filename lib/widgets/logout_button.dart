import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor:  AppConst.colorSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove(AppConst.loginSessionPrefKey);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
