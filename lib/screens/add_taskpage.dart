import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/helpers/colors.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/models/task.dart';
import 'package:todo/widgets/custom_button.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({this.task});
  final Task task;
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  Task task = Task();
  bool loading = false;
  String error = "";
  String get addOrEdit => widget.task == null ? "Add New" : "Edit";

  onConfirm() {
    loading = true;
    if (task.name == null) {
      _showError("Please Enter Task");
      loading = false;
      return;
    }
    if (widget.task == null) {
      task.createdAt = DateTime.now().millisecondsSinceEpoch;
      firebase.createTask(task).then((data) {
        Navigator.pop(context);
        setState(() {
          loading = false;
        });
      }).catchError((e) {
        setState(() {
          loading = false;
        });
        _showError(e.message);
        print(e.message);
      });
    } else {
      task.createdAt = widget.task.createdAt;
      firebase.updateTask(taskId: widget.task.id, taskData: task).then((value) {
        Navigator.pop(context);
        setState(() {
          loading = false;
        });
      }).catchError((e) {
        setState(() {
          loading = false;
        });
        _showError(e.message);
        print(e.message);
      });
    }
  }

  _showError(message) {
    setState(() {
      error = message;
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        error = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.darkDisabledColor,
                    borderRadius: BorderRadius.circular(8)),
                height: 5,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$addOrEdit Task",
                textAlign: TextAlign.start,
                // style: Theme.of(context).primaryTextTheme.headline5,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              initialValue: widget.task?.name ?? "",
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  labelText: 'ENTER TASK NAME'),
              onChanged: (value) {
                task.name = value;
              },
            ),
            SizedBox(height: 20.0),
            AnimatedContainer(
              duration: Duration(milliseconds: 150),
              width: double.maxFinite,
              padding: error.isNotEmpty
                  ? EdgeInsets.only(left: 8.0, bottom: 4, top: 4)
                  : EdgeInsets.zero,
              child: error.isNotEmpty
                  ? Text(
                      error,
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .caption
                          .copyWith(
                              color: AppColors.red,
                              fontStyle: FontStyle.italic),
                    )
                  : SizedBox(),
            ),
            SizedBox(height: 20),
            CustomButton(
              label: "$addOrEdit Task",
              onPress: onConfirm,
              loading: loading,
            ),
          ],
        ),
      ),
    );
  }
}
