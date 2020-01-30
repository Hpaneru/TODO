import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo/todo.dart';
import 'services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();

  File _image;
  User userInfo = User();
  String _password;
  bool loading = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("SIGNUP"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                              image: _image == null
                                  ? AssetImage("img/camera.png")
                                  : FileImage(_image),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 7.0, color: Colors.black)
                          ]),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'FULL NAME'),
                    onChanged: (value) {
                      setState(() {
                        userInfo.name = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "PLEASE ENTER YOUR NAME";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'EMAIL'),
                    onChanged: (value) {
                      setState(() {
                        userInfo.email = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'PLEASE ENTER EMAIL';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'PASSWORD'),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "PLEASE ENTER PASSWORD";
                      } else {
                        if (value.length < 6) return "MUST BE MORE THAN 6";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'ADDRESS'),
                    onChanged: (value) {
                      setState(() {
                        userInfo.address = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "PLEASE ENTER ADDRESS";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'PHONE'),
                    onChanged: (value) {
                      setState(() {
                        userInfo.phone = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "PLEASE ENTER PHONE NO.";
                      } else {
                        if (value.length < 10) return "MUST BE EQUAL T0 10";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  FlatButton(
                    child: loading == true
                        ? CircularProgressIndicator()
                        : Text('Sign Up'),
                    textColor: Colors.blue,
                    onPressed: () {
                      setState(() {
                        if (_formKey.currentState.validate()) {
                          loading = true;
                        }
                      });
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: userInfo.email, password: _password)
                          .then((signedInUser) async {
                        userInfo.id = signedInUser.user.uid;

                        if (_image !=null){
                        var imageUrl = await uploadFile(userInfo.id);
                        userInfo.imageUrl = imageUrl;
                        }
                        
                        UserManagement().storeNewUser(userInfo, context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => ToDo()));
                      }).catchError((e) {
                         setState(() {
                          loading = false;
                        });
                        print(e.message);
                        showSnackBar(e.message);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uploadFile(String uid) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('ProfilePictures/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }
}

class User {
  String id;
  String email;
  String name;
  String address;
  String phone;
  String imageUrl;

  User(
      {this.id,
      this.email,
      this.name,
      this.address,
      this.phone,
      this.imageUrl});
}
