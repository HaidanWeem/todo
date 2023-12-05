import 'package:flutter/material.dart';
import 'package:todo/feature/presentation/screens/login_page.dart';
import 'package:todo/feature/presentation/screens/main_screen_todo.dart';
import 'package:todo/feature/presentation/screens/signup_page.dart';

abstract class Routes {
  static const String auth = 'signIn';
  static const String signUp = 'signUp';
  static const String homePage = 'homePage';
}

class TodoNavigator {
  final initialRoute = Routes.auth;
  final routes = <String, Widget Function(BuildContext)>{
    Routes.auth: (context) => LoginPage(),
    Routes.signUp: (context) => SignUpPage(),
    Routes.homePage: (context) => const TodoMainScreen(),
  };
}
