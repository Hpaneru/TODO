import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/todo.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseUser currentUser;
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
    });
  }

  File _image;

  String name;
  String address;
  String phno;

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
          title: Text("Edit Profile"),
        ),
        body: SingleChildScrollView(
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
                              color: Colors.red,
                              image: DecorationImage(
                                  image: _image != null
                                      ? FileImage(_image)
                                      : AssetImage('img/image.png'),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(75.0)),
                              boxShadow: [
                                BoxShadow(blurRadius: 7.0, color: Colors.black)
                              ])),
                    ),
                    SizedBox(height: 40.0),
                    TextField(
                        decoration: InputDecoration(hintText: 'FULL NAME'),
                        onChanged: (value) {
                          setState(() {
                            name = value;
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
                      child: Text('UPDATE'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      elevation: 7.0,
                      onPressed: () {
                       updateData();
                      },
                    ),
                  ],
                )),
          ),
        ));
  }

  updateData() {
    try {
      Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .updateData({'name': name, 'address': address, 'phone': phno});
      updateFile();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> updateFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('ProfilePictures/${currentUser.uid}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ToDo()));
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }
}
