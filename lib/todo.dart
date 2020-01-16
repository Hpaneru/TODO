import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/completed.dart';
import 'package:todo/edit.dart';
import 'package:todo/login.dart';
import './add_taskpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final db = Firestore.instance;
  static Todo todo;
  List<Todo> list;

  @override
  void initState() {
    asyncInit();
    super.initState();
  }
             

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  asyncInit() async {
    await db
        .collection("info")
        .where("completed", isEqualTo: false)
        .getDocuments()
        .then((querySnapshot) {
      var data = querySnapshot.documents;
      list = data
          .map((m) => Todo(
              id: m.data['id'],
              complete: m.data['completed'],
              title: m.data['title']))
          .toList();
      setState(() {});
    });
  }
        


  addToList(Todo todo) {
    setState(() {
      list.add(todo);
    });
    showSnackBar("TASK ADDED");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('TODO'),
        backgroundColor: Colors.purpleAccent,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
           UserAccountsDrawerHeader(
             accountName: Text(
               "HEMANT PANERU"
             ),
             accountEmail: Text(
               "hpaneru.hp@gmail.com"
             ),
             currentAccountPicture: CircleAvatar(
              //backgroundColor: Colors.purpleAccent,
              backgroundImage: AssetImage('image/img1.jpeg'),
             ),
           ),
            ListTile(
              title: Text('HOME'),
              onTap: () {
                _handleRefresh();
                Navigator.pop(context);
              },
               
            ),
            ListTile(
              title: Text('COMPLETED TASK'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Completed()));
              },
            ),
             ListTile(
              title: Text('PROFILE'),
              onTap: () {
               // Navigator.push(context,
                // MaterialPageRoute(builder: (context) => Profile()));
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
              onTap: () {
                 FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(builder: (context)=> LoginPage())
                           );
                    }).catchError((e) {
                      print(e);
                    });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    child: AddTaskPage(addToList),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))));
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body:list==null
      ? Center(
        child: CircularProgressIndicator(),
      ):
      list.length==0
             ? Center(
               child: Text("NO UNCOMPLETE TODOS"),
             )
          : new RefreshIndicator(
              child: buildBody(),
              onRefresh: _handleRefresh,
            ),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return buildItem(list[index], index);
      },
    );
  }


  editItem(Todo item, index, id) async {
    setState(() {
      list[index] = item;
    });
    await db
        .collection('info')
        .document(item.id)
        .updateData({'title': item.title});
    showSnackBar("TASK EDITED");
  }

  showEditDialog(int index) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext edit) {
          return Dialog(
              child: EditPage(editItem, index, list[index]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))));
        });
  }

  Widget buildItem(Todo item, index) {
    return Dismissible(
        key: Key(item.hashCode.toString()),
        onDismissed: (direction) => removeItem(item),
        background: Container(
          child: Icon(Icons.delete),
        ),
        child: ListTile(
          title: GestureDetector(
              child: Text(item.title), onTap: () => showEditDialog(index)),
          trailing: Checkbox(
              value: item.complete,
              onChanged: (status) {
                setCompleteness(item, status);
              }),
        ));
  }

  void setCompleteness(Todo item, bool status) {
    setState(() {
      print(status);
      item.complete = status;
      db.collection('info').document(item.id).updateData({'completed': status});
      if (status == true) {
        setState(() {
          list.remove(item);
          showSnackBar("TASK COMPLETED");
        });
      }
    });
  }

  void removeItem(Todo item) async {
    setState(() {
      list.remove(item);
      showSnackBar("TASK DELETED");
    });
    await db.collection("info").document(item.id).delete();
  }

  Future<void> _handleRefresh() async {
    Future.delayed(Duration(seconds: 1)).then((onValue) {
      asyncInit();
    });
  }
}

class Todo {
  String title;
  bool complete;
  String id;

  Todo({this.title, this.complete = false, this.id});
}