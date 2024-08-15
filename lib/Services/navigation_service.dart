import 'package:chatapp/pages/Homepage.dart';
import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:chatapp/pages/spalashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/userprofilepage.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorkey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/SplashScreen" : (context) => SplashScreen(),
  "/login" : (context) => Loginpage(),
    "/register" : (context) => RegisterPage(),
    "/home" : (context) => Homepage(),
    "/profilepage" : (context) => Userprofilepage(),
};

GlobalKey<NavigatorState>? get navigatorkey{
  return _navigatorkey;
}
  Map<String, Widget Function(BuildContext)> get routes {
  return _routes;
  }
  NavigationService() {
    _navigatorkey=GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route) {
  _navigatorkey.currentState?.push(route);
  }

  void pushnamed(String routname) {
  _navigatorkey.currentState?.pushNamed(routname);
  }

  void pushReplacementnamed(String routname) {
    _navigatorkey.currentState?.pushReplacementNamed(routname);
  }

  void goback() {
  _navigatorkey.currentState?.pop();
  }
}