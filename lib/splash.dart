import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/login.dart';
//import 'package:todo/login.dart';
//import 'package:todo/todo.dart';
//import 'dart:async';

import 'package:todo/todo.dart';
class Splash extends StatefulWidget {
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) {
      if(user!=null){
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => ToDo()));
      }
      else{
         Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.redAccent,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }
}
