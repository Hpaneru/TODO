import 'package:flutter/material.dart';
import 'package:todo/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/todo.dart';


class EditPage extends StatefulWidget {
  EditPage(this.editItem, this.index, this.item);
  final Todo item;
  final int index;
  final Function(Todo item, int index, String id) editItem;
 
  @override
  _EditPageState createState() => _EditPageState();

  void addToList({String title, bool complete, String id}) {}
}

class _EditPageState extends State<EditPage> {
  String edit;
 
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
                child: Text(
              'EDIT TASK HERE!!!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
            SizedBox(
              height: 24,
            ),
            TextField(
              onChanged: (value) {
                edit = value;
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
                  onPressed: () {
                    Todo updatedTodo =widget.item;
                    updatedTodo.title= edit;
                    widget.editItem(updatedTodo, widget.index, widget.item.id);
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