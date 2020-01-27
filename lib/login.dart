import 'package:flutter/material.dart';
import 'package:todo/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/todo.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
            child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.blueAccent[700],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50.0),
            TextField(
                decoration: InputDecoration(hintText: 'EMAIL'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                }),
            SizedBox(height: 30.0),
            TextField(
              decoration: InputDecoration(hintText: 'PASSWORD'),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
            ),
            SizedBox(height: 60.0),
            FlatButton(
              child:
                  loading == true ? CircularProgressIndicator() : Text('Login'),
              textColor: Colors.blue,
              onPressed: () {
                setState(() {
                  loading = true;
                });
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _email, password: _password)
                    .then((AuthResult user) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => ToDo()));
                }).catchError((e) {
                  print(e);
                });
              },
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('Don\'t have an account?'),
                FlatButton(
                  child: Text('Sign Up'),
                  textColor: Colors.blue,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signup(),
                        ));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    )));
  }
}
