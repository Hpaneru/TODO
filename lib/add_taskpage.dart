import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/button.dart';
import 'todo.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage(this.addToList);
  final Function addToList;
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final db = Firestore.instance;

  String task;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
                child: Text(
              'ADD NEW TASK HERE!!!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
            SizedBox(
              height: 24,
            ),
            TextField(
              onChanged: (value) {
                task = value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  labelText: 'ENTER TASK NAME'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Button(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttontext: "Cancel",
                ),
                Button(
                  onPressed: () async {
                    String id = db.collection("info").document().documentID;
                    await  db.collection("info").document(id).setData({"title": task,"id":id,"completed":false});    
                    widget.addToList(Todo(title: task, complete: false, id:id));
                    Navigator.pop(context);
                  },
                  buttontext: "Save",
                )
              ],
            )
          ],
        ));
  }
}


