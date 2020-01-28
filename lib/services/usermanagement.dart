import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/signup.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  FirebaseUser firebaseUser;
 
  storeNewUser(User result, context) async{
   var ref=Firestore.instance.collection('users');
  await ref.document(result.id).setData({
      'email': result.email,
      'uid': result.id,
      'name':result.name,
      'address':result.address,
      'phone':result.phone,
      'imageUrl':result.imageUrl
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/ToDO');
    }).catchError((e) {
      print(e);
    });
  }
  
}