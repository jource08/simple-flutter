import 'dart:ui';

class AppConst {
  static const String baseUrl = "http://192.168.1.243:8080";
  static const String imgBaseUrl = "http://192.168.1.243:8080/images";

  static const String loginUrl = "$baseUrl/auth/login";
  static const String listUserUrl = "$baseUrl/users";

  static const String loginSessionPrefKey = "session";
  static const String userPrefKey = "user";

  static const Color colorPrimary = Color(0xFFee2c3c);
  static const Color colorSecondary = Color(0xFFffd540);
}
