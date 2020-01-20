import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/todo.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

    void initState() {
    asyncInit();
    super.initState();
  }

  asyncInit() async {
    // final FirebaseUser user =await auth.currentUser();
    // final uid=user.uid;
  }


  File _image;
  // String _email;
  // String _password;

  String name;
  String address;
  String phno;

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
          .document('1GTCOphCMRSLHHVf0YhieNaTv9d2')
          .updateData({'name': name, 'address': address, 'phone': phno});
      print('updated');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ToDo()));
    } catch (e) {
      print(e.toString());
    }
  }
}
