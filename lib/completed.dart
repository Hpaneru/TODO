import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/main.dart';

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  final GlobalKey<ScaffoldState> _scaffoldnew = new GlobalKey<ScaffoldState>();

  final db = Firestore.instance;
  List<Todo> list;

  @override
  void initState() {
    db
        .collection("info")
        .where("completed", isEqualTo: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (list == null) {
        list = [];
      }
      snapshot.documents.forEach((f) {
        list.add(Todo(
            title: f.data["title"],
            complete: f.data["completed"],
            id: f.data["id"]));
      });
      setState(() {});
    });
    super.initState();
  }

  void showSnackBar(String value) {
    _scaffoldnew.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldnew,
      appBar: AppBar(
        title: Text("COMPLETED TASK"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: list == null
          ? Center(child: CircularProgressIndicator())
          : list.length == 0
              ? Center(
                  child: Text("NO TODOS TO COMPLETE"),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    var item = list[index];
                    return buildItem(item, index);
                  },
                ),
    );
  }
  Widget buildItem(Todo item, index) {
    return Dismissible(
        key: Key(item.hashCode.toString()),
        onDismissed: (direction) => removeItem(item),
        background: Container(
          child: Icon(Icons.delete),
        ),
        child: ListTile(
          title: Text(item.title),
          trailing: Checkbox(
              value: item.complete,
              onChanged: (status) {
                setCompleteness(item, status);
              }),
        ));
  }

  void removeItem(Todo item) async {
    setState(() {
      list.remove(item);
      showSnackBar("TASK DELETED");
    });
    await db.collection("info").document(item.id).delete();
  }

  void setCompleteness(Todo item, bool status) {
    setState(() {
      print(status);
      item.complete = status;
      db.collection('info').document(item.id).updateData({'completed': status});
      if (status == false) {
        db
            .collection('info')
            .document(item.id)
            .updateData({'completed': status});
        setState(() {
          list.remove(item);
        });
      }
    });
    showSnackBar("TASK UNCOMPLETED");
  }
}
