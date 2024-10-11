import 'dart:ui';

class AppConst {

  static const String baseUrl = "http://192.168.1.8:8080";
  static const String imgBaseUrl = "$baseUrl/images";

  static const String loginUrl = "$baseUrl/auth/login";
  static const String registerUrl = "$baseUrl/auth/register";
  static const String listUserUrl = "$baseUrl/users";

  static const String loginSessionPrefKey = "session";
  static const String userPrefKey = "user";
  static const String cookiePrefKey = "auth_cookie";

  static const Color colorPrimary = Color(0xFFee2c3c);
  static const Color colorSecondary = Color(0xFFffd540);
}
