import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/screens/editprofile.dart';
import 'package:todo/screens/login.dart';
import 'package:todo/screens/home.dart';

class Splash extends StatefulWidget {
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  handelResult(user) async {
    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else {
      bool valid = await firebase.checkUserStatus(user);
      if (valid) {
        manageBaseRoutes(user);
      } else {
        await firebase.logout();
      }
    }
  }

  manageBaseRoutes(FirebaseUser user) async {
    if (user.displayName == null || user.displayName.isEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EditProfile(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  savedUser() async {
    firebase.getUserStateListener().listen((data) async {
      handelResult(data);
    });
  }

  @override
  void initState() {
    super.initState();
    savedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
