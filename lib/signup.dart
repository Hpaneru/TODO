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
  File _image;
  User userInfo=User();
  String _password;
 
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ), SizedBox(height: 15.0),
                    GestureDetector(
                      onTap: getImage,
                      child: Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                  image:
                                  _image != null         
                                     ? FileImage(_image)
                                      : AssetImage('img/image.png'),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(75.0)),
                              boxShadow: [
                                BoxShadow(blurRadius: 7.0, color: Colors.black)
                              ])),
                    ),
                 SizedBox(height: 15.0),
                TextField(
                    decoration: InputDecoration(hintText: 'FULL NAME'),
                    onChanged: (value) {
                      setState(() {
                       userInfo.name = value;
                      });
                    }),
                SizedBox(height: 15.0),
                TextField(
                    decoration: InputDecoration(hintText: 'EMAIL'),
                    onChanged: (value) {
                      setState(() {
                        userInfo.email= value;
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
                        userInfo.address = value;
                      });
                    }),   
                 SizedBox(height: 15.0),
                TextField(
                    decoration: InputDecoration(hintText: 'PHONE'),
                    onChanged: (value) {
                      setState(() {
                        userInfo.phone = value;
                      });
                    }),    
                SizedBox(height: 15.0),
                RaisedButton(
                  child: Text('Sign Up'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 7.0,
                  onPressed: () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: userInfo.email, password: _password)
                        .then((signedInUser) async{
                         
                      userInfo.id =   signedInUser.user.uid;
                          
                      var imageUrl = await uploadFile(userInfo.id); 
                      userInfo.imageUrl = imageUrl;

                      UserManagement().storeNewUser(userInfo, context);
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
  Future<String> uploadFile(String uid) async{
    StorageReference storageReference = FirebaseStorage.instance
    .ref()
    .child('ProfilePictures/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print("fileeeeeeeeeeee uploadedddddddddddd");
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }
}
class User{
  String id;
  String email;
  String name;
  String address;
  String phone;
  String imageUrl;

  User({this.id, this.email, this.name, this.address, this.phone, this.imageUrl});
}