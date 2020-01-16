import 'package:flutter/material.dart';
import 'package:todo/todo.dart';
import 'services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}
 
class _SignupState extends State<Signup> {
  String _email;
  String _password;

  String name;
  String address;
  String phno;
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: SingleChildScrollView(
                  child: Center(
      child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("SIGNUP",
                 style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.blueAccent[700],
                  fontWeight: FontWeight.bold),
                    ),
                 SizedBox(height: 15.0),
                TextField(
                    decoration: InputDecoration(hintText: 'FULL NAME'),
                    onChanged: (value) {
                      setState(() {
                       name = value;
                      });
                    }),
                SizedBox(height: 15.0),
                TextField(
                    decoration: InputDecoration(hintText: 'EMAIL'),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    }),
                SizedBox(height: 15.0),
                TextField(
                    decoration: InputDecoration(hintText: 'PASSWORD'),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    }),
                SizedBox(height: 15.0),
                TextField(
                    decoration: InputDecoration(hintText: 'ADDRESS'),
                    onChanged: (value) {
                      setState(() {
                        address = value;
                      });
                    }),   
                 SizedBox(height: 15.0),
                TextField(
                    decoration: InputDecoration(hintText: 'PHONE'),
                    onChanged: (value) {
                      setState(() {
                        phno = value;
                      });
                    }),    
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('Sign Up'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 7.0,
                  onPressed: () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _email, password: _password,)
                        .then((signedInUser) {
                      UserManagement().storeNewUser(signedInUser, context);
                        Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(builder: (context)=> ToDo())
                         );
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
              ],
            )),
    ),
        ));
  }
}