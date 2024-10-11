import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/providers/login_provider.dart';
import 'package:myapp/providers/registration_provider.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/providers/user_list_provider.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionProvider>(
          create: (context) => SessionProvider(),
        ),
        ChangeNotifierProvider<UserListProvider>(
          create: (context) => UserListProvider(),
        ),
        ChangeNotifierProvider<RegistrationProvider>(
          create: (context) => RegistrationProvider(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
      ],
      child: MaterialApp(
        title: "Simple Flutter",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppConst.colorPrimary),
          primaryColor: AppConst.colorPrimary,
          useMaterial3: true,
        ),
        home: FutureBuilder<String?>(
          future: getUserSession(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for the session data
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              // If session exists, navigate to MainScreen
              setSession(context, snapshot.data);
              return const MainScreen();
            } else {
              // If no session, show LoginScreen
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

void setSession(BuildContext context, String? data) {
  var mydata = jsonDecode(data ?? "{}");

  User user = User(
    id: mydata[AppConst.userPrefKey]["id"],
    username: mydata[AppConst.userPrefKey]["username"],
    email: mydata[AppConst.userPrefKey]["email"],
    fullname: mydata[AppConst.userPrefKey]["fullname"],
    bio: mydata[AppConst.userPrefKey]["bio"],
    profileImageUrl: mydata[AppConst.userPrefKey]["profile_image_url"],
  );

  // Defer the state change until after the build process is complete
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Set user and warehouse in SessionProvider
    Provider.of<SessionProvider>(context, listen: false).setUser(user);
  });
}

// Retrieve user session from SharedPreferences
Future<String?> getUserSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // print(prefs.getString(AppConst.loginSessionPrefKey));
  return prefs.getString(
      AppConst.loginSessionPrefKey); // Returns the session value if it exists
}
