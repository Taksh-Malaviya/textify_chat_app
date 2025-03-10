import 'package:chat_app/screen/Detail.dart';
import 'package:chat_app/screen/view/auth/Login/login.dart';
import 'package:chat_app/screen/view/auth/Register/register.dart';
import 'package:chat_app/screen/view/home.dart';
import 'package:chat_app/screen/view/splash/splash.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = "/";
  static String login = "/login";
  static String register = "/Register";
  static String home = "/home";
  static String detail = "/detail";

  static List<GetPage> getPages = [
    GetPage(
      name: splash,
      page: () => const Splash(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: login,
      page: () => const Login(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: register,
      page: () => const Register(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: home,
      page: () => HomePage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: detail,
      page: () => DetailPage(),
      transition: Transition.cupertino,
    ),
  ];
}
