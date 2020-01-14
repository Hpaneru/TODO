import 'package:flutter/material.dart';
import 'package:todo/main.dart';
import './main.dart';
import 'dart:async';

class Splash extends StatefulWidget{
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(
        seconds: 2,
      ),
      (){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ToDo(),
          )
        );
      }
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.redAccent,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }
}