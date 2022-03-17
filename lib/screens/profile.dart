import 'package:flutter/material.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/models/user.dart';
import 'package:todo/screens/editprofile.dart';
import 'package:todo/widgets/custom_appBar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User user;

  updateProfile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditProfile();
            },
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "EDIT",
          style: Theme.of(context)
              .primaryTextTheme
              .subtitle2
              .copyWith(fontSize: 10, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    firebase.getUserInfo(uid: firebase.getCurrentUser().uid).then((data) {
      setState(() {
        user = data;
      });
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
      body: SafeArea(
        child: Column(
          children: [
            CustomAppbar(
              "Profile",
              goBack: false,
              actions: <Widget>[
                updateProfile(),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).primaryColor.withAlpha(40),
                      backgroundImage: NetworkImage(user?.imageUrl ?? ""),
                      child: user?.imageUrl == null
                          ? Icon(Icons.person,
                              // color: AppColors.settingTextColor.withAlpha(100),
                              size: MediaQuery.of(context).size.width * 0.25)
                          : SizedBox(),
                      radius: MediaQuery.of(context).size.width * 0.15,
                    ),
                    // Container(
                    //     width: 150.0,
                    //     height: 150.0,
                    //     decoration: BoxDecoration(
                    //         color: Colors.blue,
                    //         image: DecorationImage(
                    //             image: userInfo["imageUrl"] != null
                    //                 ? NetworkImage(userInfo["imageUrl"])
                    //                 : AssetImage("img/camera.png"),
                    //             fit: BoxFit.cover),
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(75.0)),
                    //         boxShadow: [
                    //           BoxShadow(blurRadius: 7.0, color: Colors.black)
                    //         ])),
                    // SizedBox(height: 30.0),
                    // Text(
                    //   userInfo["name"],
                    //   style: TextStyle(
                    //       fontSize: 30.0,
                    //       fontWeight: FontWeight.bold,
                    //       fontFamily: 'Montserrat'),
                    // ),
                    // SizedBox(height: 30.0),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Text(
                    //         "Email:- ",
                    //         style: TextStyle(
                    //             fontSize: 20.0,
                    //             fontWeight: FontWeight.bold,
                    //             fontFamily: 'Montserrat'),
                    //       ),
                    //       Text(
                    //         userInfo["email"],
                    //         style: TextStyle(
                    //             fontSize: 20.0,
                    //             fontWeight: FontWeight.bold,
                    //             fontFamily: 'Montserrat'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 20.0),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Text(
                    //         "Address:- ",
                    //         style: TextStyle(
                    //             fontSize: 20.0,
                    //             fontWeight: FontWeight.bold,
                    //             fontFamily: 'Montserrat'),
                    //       ),
                    //       Text(
                    //         userInfo["address"],
                    //         style: TextStyle(
                    //             fontSize: 20.0,
                    //             fontWeight: FontWeight.bold,
                    //             fontFamily: 'Montserrat'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 20.0),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Text(
                    //         "Phone:- ",
                    //         style: TextStyle(
                    //             fontSize: 20.0,
                    //             fontWeight: FontWeight.bold,
                    //             fontFamily: 'Montserrat'),
                    //       ),
                    //       Text(
                    //         userInfo["phone"],
                    //         style: TextStyle(
                    //             fontSize: 20.0,
                    //             fontWeight: FontWeight.bold,
                    //             fontFamily: 'Montserrat'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 25.0),
                    // Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       RaisedButton(
                    //           child: Text('Edit Profile'),
                    //           textColor: Colors.blue,
                    //           onPressed: () {
                    //             Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) => EditProfile()));
                    //           }),
                    //       RaisedButton(
                    //           child: Text('Log Out'),
                    //           textColor: Colors.blue,
                    //           onPressed: () {
                    //             FirebaseAuth.instance.signOut().then((value) {
                    //               Navigator.pushReplacement(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => LoginScreen()));
                    //             }).catchError((e) {
                    //               print(e);
                    //             });
                    //             Navigator.pop(context);
                    //           })
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
