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
  var _formKey = GlobalKey<FormState>();
  Map<dynamic, dynamic> userInfo;
  FirebaseUser currentUser;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      asyncInit();
    });
  }

  asyncInit() async {
    await Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .get()
        .then((snapshot) {
      setState(() {
        userInfo = snapshot.data;
      });
    });
  }

  File _image;
  String name;
  String address;
  String phno;
  bool loading = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: userInfo == null
            ? SizedBox()
            : Form(
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
                                            ? NetworkImage(userInfo["imageUrl"])
                                            : FileImage(_image),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(75.0)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 7.0, color: Colors.black)
                                    ]),
                              ),
                            ),
                            SizedBox(height: 40.0),
                            TextFormField(
                              initialValue: userInfo["name"],
                              decoration:
                                  InputDecoration(hintText: 'FULL NAME'),
                              onChanged: (value) {
                                setState(() {
                                  userInfo["name"] = value;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "PLEASE ENTER FULL NAME";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              initialValue: userInfo["address"],
                              decoration: InputDecoration(hintText: 'ADDRESS'),
                              onChanged: (value) {
                                setState(() {
                                  userInfo["address"] = value;
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
                              initialValue: userInfo["phone"],
                              decoration: InputDecoration(hintText: 'PHONE'),
                              onChanged: (value) {
                                setState(() {
                                  userInfo["phone"] = value;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "PLEASE ENTER PHONE";
                                } else {
                                  if (value.length < 10)
                                    return "MUST BE EQUAL T0 10";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 50.0),
                            FlatButton(
                              child: loading == true
                                  ? CircularProgressIndicator()
                                  : Text('UPDATE'),
                              textColor: Colors.blue,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  updateData();
                                }
                              },
                            ),
                          ],
                        )),
                  ),
                )));
  }
  updateData() async {
    setState(() {
      loading = true;
    });
    try {
      if (_image != null) await updateFile();
      Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .updateData({
        'name': userInfo["name"],
        'address': userInfo["address"],
        'phone': userInfo["phone"]
      }).then((_){
         Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ToDo()));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateFile() async  {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('ProfilePictures/${currentUser.uid}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
  }
}
