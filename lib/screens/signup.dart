import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/models/user.dart';
import 'package:todo/screens/editprofile.dart';
import 'package:todo/widgets/custom_button.dart';
import 'package:todo/widgets/custom_shape.dart';
import 'package:todo/widgets/responsive_ui.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();

  User userInfo = User();
  String email, password;
  double _height, _width, _pixelRatio;
  bool showPassword = false,
      autoValidate = false,
      loading = false,
      _large,
      _medium;
  File image;

  showLoading(value) {
    setState(() {
      loading = value;
    });
  }

  registerUser() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showLoading(true);
      firebase.signup(email, password).then((data) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfile(),
          ),
        );
        showLoading(false);
      }).catchError((err) {
        if (err is PlatformException) {
          showSnackbar(err.message);
          showLoading(false);
        } else
          showSnackbar("Something Went Wrong. Please Try Again Later");
        showLoading(false);
      });
    }
  }

  showSnackbar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).accentColor,
      content: Text(message),
    ));
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
            top:
                _large ? _height / 30 : (_medium ? _height / 25 : _height / 20),
          ),
          child: Image.asset(""
              //TODO to implement For pic;
              // height: _height/3.5,
              // width: _width/3.5,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                clipShape(),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "SIGNUP",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        TextFormField(
                          autovalidate: autoValidate,
                          decoration: InputDecoration(
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelText: "YOUR EMAIL",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withAlpha(120)),
                          ),
                          validator: (value) {
                            value = value.trim();
                            if (value.isEmpty)
                              return "Mandatory Field";
                            else if (!firebase.isEmail(value))
                              return "Invalid Email";
                            return null;
                          },
                          onSaved: (value) {
                            email = (value ?? "").trim();
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          obscureText: true,
                          autovalidate: autoValidate,
                          decoration: InputDecoration(
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelText: "PASSWORD",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withAlpha(120)),
                          ),
                          validator: (value) {
                            if (value.isEmpty) return "mandatory field";

                            if (value.length > 20) return "password too long";
                            return null;
                          },
                          onSaved: (value) {
                            password = value;
                          },
                        ),
                        SizedBox(height: 100),
                        CustomButton(
                          onPress: registerUser,
                          label: "SIGNUP",
                          loading: loading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
