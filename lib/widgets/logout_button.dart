import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    User blankUser = User(
      id: 0,
      username: "",
      email: "",
      fullname: "",
      bio: "",
      profileImageUrl: "",
    );
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppConst.colorSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove(AppConst.loginSessionPrefKey);
            Provider.of<SessionProvider>(context, listen: false)
                .setUser(blankUser);
            Provider.of<SessionProvider>(context, listen: false)
                .setAuthCookie("");
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
