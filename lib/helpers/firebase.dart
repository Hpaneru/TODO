import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/user.dart';
import 'package:image/image.dart' as Im;

class _FirebaseHelper {
  FirebaseMessaging _messaging = FirebaseMessaging();
  CloudFunctions functions = CloudFunctions.instance;
  FirebaseAnalytics _analytics = FirebaseAnalytics();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore();
  FirebaseUser _user;
  User _me;
  FirebaseStorage _storage = FirebaseStorage();
  User userInfo = User();
  String userType;
  _FirebaseHelper() {
    _auth.currentUser().then((u) async {
      if (u != null) {
        _user = u;
        _me = await getUserInfo();
      }
    });
  }

  init() async {
    _auth.onAuthStateChanged.listen((user) async {
      checkUserStatus(user);
    });
  }

  checkUserStatus(FirebaseUser user) async {
    if (user != null) {
      if (userType == "endUser") {
        return true;
      }
      _user = user;
      var tokenData = await user.getIdToken(refresh: true);
      return (tokenData.claims["endUser"] == true);
    }
    return false;
  }

  bool isEmail(String em) => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(em);

  Future<FirebaseUser> login(email, password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future signup(email, password) async {
    userType = "endUser";
    var user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    _user = user;
    try {
      await functions
          .getHttpsCallable(functionName: "authGroup-setEndUserClaims")
          .call({"uid": user.uid});

      await manageFirestore();
    } catch (e) {
      await functions
          .getHttpsCallable(functionName: "deleteAccount")
          .call(user.uid);
      throw (e);
    }
  }

  updateFirebaseUser({displayName, photoURL}) {
    UserUpdateInfo updateInfo = UserUpdateInfo()
      ..displayName = displayName
      ..photoUrl = photoURL;
    return _user.updateProfile(updateInfo);
  }

  Future manageFirestore() async {
    _analytics.logLogin();
    await createUser(User.fromMap({
      "email": _user.email ?? "",
      "id": _user.uid,
      "token": await _messaging.getToken(),
      "provider_id": _user.providerId,
    }));
    _me = await getUserInfo();
  }

  Future updateUser(User userData) {
    return _firestore
        .collection("users")
        .document(userData.id)
        .setData(userData.toMap(), merge: true);
  }

  Future uploadFile(File image, String path) async {
    var fileName = image.path.split('/').last;
    var ref = _storage.ref().child("$path/$fileName");
    await ref.putFile(await compressImage(image)).onComplete;
    return await ref.getDownloadURL();
  }

  Future<File> compressImage(file) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(file.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(image, height: 300, width: 300);

    return File('$path/img_$rand.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(
          smallerImage,
          quality: 80,
        ),
      );
  }

  FirebaseUser getCurrentUser() {
    return _user;
  }

  Future createUser(User userData) async {
    return _firestore
        .collection("users")
        .document(userData.id)
        .setData(userData.toMap(), merge: true);
  }

  Future<User> getUserInfo({uid}) async {
    if (uid == null) {
      if (_me != null) {
        return _me;
      }
      uid = _user.uid;
    }
    DocumentSnapshot user =
        await _firestore.collection("users").document(uid).get();
    return User.fromMap(user.data);
  }

  Stream<FirebaseUser> getUserStateListener() {
    return _auth.onAuthStateChanged;
  }

  Future logout() async {
    await _auth.signOut();
  }

  Future createTask(Task taskData) async {
    DocumentReference newTask = _firestore
        .collection("users")
        .document(_user.uid)
        .collection("todos")
        .document(taskData.id);
    taskData.id = newTask.documentID;
    taskData.userId = firebase.getCurrentUser().uid;
    return newTask.setData(taskData.toMap());
  }

  Future updateTask({taskId, taskData}) async {
    DocumentReference taskRef = _firestore
        .collection("users")
        .document(_user.uid)
        .collection("todos")
        .document(taskId);
    taskData.id = taskId;
    taskData.userId = firebase.getCurrentUser().uid;
    return taskRef.updateData(taskData.toMap());
  }

  Future deleteTask(Task taskData) async {
    return _firestore
        .collection("users")
        .document(_user.uid)
        .collection("todos")
        .document(taskData.id)
        .delete();
  }

  getTasks(
    Function(List<Task>) cb, {
    bool completed,
    userId,
  }) {
    Query taskRef =
        _firestore.collection("users").document(_user.uid).collection("todos");

    if (completed == true) {
      taskRef = taskRef
          .where("completed", isEqualTo: true)
          .where("userId", isEqualTo: userId);
    } else if (completed == false) {
      taskRef = taskRef
          .where("completed", isEqualTo: false)
          .where("userId", isEqualTo: userId);
    }
    taskRef.snapshots().listen((tasks) {
      cb(tasks.documents.map((doc) => Task.fromMap(doc.data)).toList());
    });
  }
}

final firebase = _FirebaseHelper();
