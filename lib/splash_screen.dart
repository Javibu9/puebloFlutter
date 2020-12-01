import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proyecto_pueblo/intro_page.dart';
import 'package:proyecto_pueblo/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => IntroPage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: Image.asset("images/splashfoto.jpg"),
        ),
      ),
    );
  }
}