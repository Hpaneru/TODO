import 'package:flutter/material.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/models/task.dart';
import 'package:todo/widgets/custom_container.dart';

class TaskCard extends StatefulWidget {
  TaskCard({this.task, this.onLongPress, this.completed});
  final Task task;
  final Function onLongPress;
  final bool completed;
  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  setCompleted() async {
    if (widget.completed == true) {
      Task task = widget.task;
      task.completed = false;
      task.completedAt = null;
      await firebase.updateTask(taskId: widget.task.id, taskData: task);
    } else {
      Task task = widget.task;
      task.completed = true;
      task.completedAt = DateTime.now().millisecondsSinceEpoch;
      await firebase.updateTask(taskId: widget.task.id, taskData: task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: CustomContainer(
          shadow: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.task.name,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Checkbox(
                    value: widget.task.completed,
                    onChanged: (status) {
                      setCompleted();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
