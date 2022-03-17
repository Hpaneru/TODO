import 'package:flutter/material.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/models/user.dart';
import 'package:todo/screens/completed_task.dart';
import 'package:todo/screens/login.dart';
import 'package:todo/screens/profile.dart';

class DrawerContent extends StatefulWidget {
  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  User user;
  @override
  void initState() {
    firebase.getUserInfo().then((data) {
      setState(() {
        this.user = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? ""),
            accountEmail: Text(user?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.imageUrl ?? ""),
            ),
          ),
          ListTile(
            title: Text('HOME'),
            onTap: () {
              // asyncInit();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('COMPLETED TASK'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedTask(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('PROFILE'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('ABOUT'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('LOG OUT'),
            onTap: () async {
              await firebase.logout().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              });
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
