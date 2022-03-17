import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdi/mdi.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/screens/editprofile.dart';
import 'package:todo/screens/home.dart';
import 'package:todo/screens/signup.dart';
import 'package:todo/widgets/custom_button.dart';
import 'package:todo/widgets/custom_shape.dart';
import 'package:todo/widgets/responsive_ui.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();

  String email, password;
  bool showPassword = false, autoValidate = false, loading = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  showSnackbar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).accentColor,
      content: Text(message),
    ));
  }

  showLoading(value) {
    setState(() {
      loading = value;
    });
  }

  handleResult(user) async {
    bool valid = await firebase.checkUserStatus(user);
    if (valid) {
      manageBaseRoutes(user);
    } else {
      await firebase.logout();
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

  tryLoggingIn() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showLoading(true);
      firebase.login(email, password).then((user) async {
        await handleResult(user);
        showLoading(false);
      }).catchError((err) {
        showLoading(false);
        if (err is PlatformException)
          showSnackbar(err.message);
        else
          showSnackbar("Something Went Wrong. Please Try Again Later");
      });
    }
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
              // 'assets/images/login.png',
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
          height: _height,
          width: _width,
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
                          "LOGIN",
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
                            suffixIcon: IconButton(
                                icon: Icon(showPassword ? Mdi.eye : Mdi.eyeOff),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                }),
                          ),
                          validator: (value) {
                            if (value.isEmpty) return "mandatory field";

                            if (value.length > 20) return "password too long";
                            return null;
                          },
                          onSaved: (value) {
                            password = value;
                          },
                          obscureText: !showPassword,
                          enableInteractiveSelection: true,
                        ),
                        SizedBox(height: 10),
                        FlatButton(
                          onPressed: null,
                          child: Text("Forgot Password?"),
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                          onPress: tryLoggingIn,
                          label: "LOGIN",
                          loading: loading,
                        ),
                        SizedBox(height: 60),
                        RichText(
                          text: TextSpan(
                            text: "Don't Have Account",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .copyWith(
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withAlpha(120)),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Signup',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
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
