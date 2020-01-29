import 'package:flutter/material.dart';
import 'package:todo/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/todo.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey =  GlobalKey<FormState>(); 

  String _email;
  String _password;
  bool loading = false;

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        body: Form(
          key: _formKey,   
            child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150.0),
            Text(
              "LOGIN",
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.blueAccent[700],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50.0),
            TextFormField(
                decoration: InputDecoration(hintText: 'EMAIL'),
                onChanged: (value) {
                  setState(() {
                    _email = value;

                  });
                },
                validator:(value){
                  if (value.isEmpty) {
                    return "PLEASE ENTER EMAIL";
                  }
                  return null;
                },
                ),
            SizedBox(height: 30.0),
            TextFormField(
              decoration: InputDecoration(hintText: 'PASSWORD'),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
                validator:(value){
                  if (value.isEmpty) {
                    return "PLEASE ENTER PASSWORD";
                  }
                  return null;
                },
            ),
            SizedBox(height: 60.0),
            FlatButton(
              child:
                  loading == true ? CircularProgressIndicator() : Text('Login'),
              textColor: Colors.blue,
              onPressed: () {
                setState(() {
                   if (_formKey.currentState.validate()) {
                    loading = true;
                }
                });
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _email, password: _password)
                    .then((AuthResult user) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => ToDo()));
                }).catchError((e) {
                  print(e.message);
                showSnackBar(e.message);
                setState(() {
                  loading = false;
                });
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
      )
    )));
  }
}