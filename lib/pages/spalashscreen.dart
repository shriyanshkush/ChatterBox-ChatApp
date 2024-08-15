import 'package:chatapp/Services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:chatapp/pages/login_page.dart';
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:chatapp/Services/auth_service.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  final GetIt _getIt=GetIt.instance;
  late NavigationService _navigationService;
  late Authservice _authservice;
  @override
  void initState() {
    super.initState();
    _authservice=_getIt.get<Authservice>();
    Timer(Duration( seconds: 2), () {
      _navigationService= _getIt.get<NavigationService>();
      _navigationService.pushReplacementnamed(
          _authservice.user!=null?"/home":"/login");
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "ChatterBox",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor:
    Color.fromRGBO(36, 35, 49, 1.0)),
      home: Scaffold(backgroundColor:Color.fromRGBO(36, 35, 49, 1.0),
        body: Center(child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.contain,image:AssetImage("assets/images/logo.jpg") ),
          ),

        ),),),
    );
  }

  }