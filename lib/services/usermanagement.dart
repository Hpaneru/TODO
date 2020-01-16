import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(AuthResult result, context) {
    Firestore.instance.collection('/users').add({
      'email': result.user.email,
      'uid': result.user.uid
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/ToDO');
    }).catchError((e) {
      print(e);
    });
  }
}