import 'package:flutter/material.dart';
import 'package:todo/feature/presentation/screens/calendar_page.dart';
import 'package:todo/feature/presentation/screens/login_page.dart';
import 'package:todo/feature/presentation/screens/main_screen_todo.dart';
import 'package:todo/feature/presentation/screens/signup_page.dart';

abstract class Routes {
  static const auth = 'signIn';
  static const signUp = 'signUp';
  static const homePage = 'homePage';
  static const calendar = 'calendar';
}

class TodoNavigator {
  final initialRoute = Routes.auth;
  final routes = <String, Widget Function(BuildContext)>{
    Routes.auth: (context) => LoginPage(),
    Routes.signUp: (context) => SignUpPage(),
    Routes.homePage: (context) => const TodoMainScreen(),
    Routes.calendar: (context) => const CalendarPage()
  };
}
