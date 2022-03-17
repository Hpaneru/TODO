import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';
import 'package:todo/helpers/colors.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/models/task.dart';
import 'package:todo/screens/add_taskpage.dart';
import 'package:todo/screens/drawer.dart';
import 'package:todo/widgets/custom_appBar.dart';
import 'package:todo/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Task> tasks;
  Map<String, List<Task>> taskMap = {};
  var now = DateTime.now();

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  addTask({task}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: AddTaskScreen(task: task),
        );
      },
    );
  }

  showEditDialog(task) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundColor,
          children: <Widget>[
            ListTile(
              title: Text("Edit"),
              leading: Icon(Mdi.pencil),
              onTap: () {
                Navigator.pop(context);
                addTask(task: task);
              },
            ),
            Divider(),
            ListTile(
              title: Text("Delete"),
              leading: Icon(Mdi.delete),
              onTap: () async {
                await firebase.deleteTask(task).then((value) {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  int getBaseTimeStamp({DateTime date, int timestamp}) {
    if (date == null) {
      if (timestamp == null) {
        return null;
      }
      date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    return date
        .subtract(Duration(
          hours: date.hour,
          minutes: date.minute,
          seconds: date.second,
          milliseconds: date.millisecond,
          microseconds: date.microsecond,
        ))
        .millisecondsSinceEpoch;
  }

  sortTasks() {
    tasks.sort((task1, task2) {
      return task1.createdAt - task2.createdAt;
    });

    taskMap = {};
    tasks.forEach((task) {
      if (getBaseTimeStamp(timestamp: task.createdAt) ==
          getBaseTimeStamp(date: DateTime.now())) {
        if (taskMap["today"] == null) {
          taskMap["today"] = [task];
        } else if (!taskMap["today"].contains(task)) {
          taskMap["today"].add(task);
        }
      } else if (getBaseTimeStamp(timestamp: task.createdAt) ==
          getBaseTimeStamp(date: DateTime.now().subtract(Duration(days: 1)))) {
        if (taskMap["yesterday"] == null) {
          taskMap["yesterday"] = [task];
        } else if (!taskMap["yesterday"].contains(task)) {
          taskMap["yesterday"].add(task);
        }
      } else if (task.createdAt < DateTime.now().millisecondsSinceEpoch) {
        if (taskMap["other"] == null) {
          taskMap["other"] = [task];
        } else if (!taskMap["other"].contains(task)) {
          taskMap["other"].add(task);
        }
      } else {
        if (taskMap["past"] == null) {
          taskMap["past"] = [task];
        } else if (!taskMap["past"].contains(task)) {
          taskMap["past"].add(task);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    firebase.getTasks((data) {
      setState(() {
        tasks = data;
      });
      sortTasks();
    }, completed: false, userId: firebase.getCurrentUser().uid);
  }

  @override
  Widget build(BuildContext context) {
    if (tasks == null)
      Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   // title: Text(
      //   //   "Home",
      //   // ),
      // ),
      drawer: DrawerContent(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          addTask();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomAppbar(
              "Task",
              goBack: false,
            ),
            if (tasks?.length == 0)
              Expanded(
                child: Center(
                  child: Text("No Todo"),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      if (taskMap["yesterday"] != null &&
                          taskMap["yesterday"].length != 0)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Yesterday",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                    Text(
                                      DateFormat("dd/MM/y")
                                          .format(
                                              now.subtract(Duration(days: 1)))
                                          .toString(),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: AppColors.dateTimeColor,
                                              fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  children: <Widget>[
                                    taskMap["yesterday"] == null
                                        ? SizedBox()
                                        : Column(
                                            children: taskMap["yesterday"]
                                                .map<Widget>((task) {
                                              return Column(children: <Widget>[
                                                TaskCard(
                                                  task: task,
                                                  onLongPress: () =>
                                                      showEditDialog(task),
                                                ),
                                                // if (taskMap["yesterday"]
                                                //         .indexOf(task) !=
                                                //     taskMap["yesterday"]
                                                //             .length -
                                                //         1)
                                                //   Divider(
                                                //     height: 1,
                                                //   ),
                                              ]);
                                            }).toList(),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      if (taskMap["today"] != null &&
                          taskMap["today"].length != 0)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 2, 0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Today",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        DateFormat("dd/MM/y")
                                            .format(now)
                                            .toString(),
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1
                                            .copyWith(
                                                color: AppColors.dateTimeColor,
                                                fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  children: <Widget>[
                                    taskMap["today"] == null
                                        ? SizedBox()
                                        : Column(
                                            children: taskMap["today"]
                                                .map<Widget>((task) {
                                              return Column(children: <Widget>[
                                                TaskCard(
                                                  task: task,
                                                  onLongPress: () =>
                                                      showEditDialog(task),
                                                ),
                                                // if (taskMap["today"]
                                                //         .indexOf(task) !=
                                                //     taskMap["today"].length - 1)
                                                //   Divider(height: 1)
                                              ]);
                                            }).toList(),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      if (taskMap["other"] != null &&
                          taskMap["other"].length != 0)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 2, 0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Past",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                    Text(
                                      taskMap["other"].length.toString(),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: AppColors.dateTimeColor,
                                              fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  children: <Widget>[
                                    taskMap["other"] == null
                                        ? SizedBox()
                                        : Column(
                                            children: taskMap["other"]
                                                .map<Widget>((task) {
                                              return Column(children: <Widget>[
                                                TaskCard(
                                                  task: task,
                                                  onLongPress: () =>
                                                      showEditDialog(task),
                                                ),
                                                // if (taskMap["other"]
                                                //         .indexOf(task) !=
                                                //     taskMap["other"].length - 1)
                                                //   Divider(
                                                //     height: 1,
                                                //   ),
                                              ]);
                                            }).toList(),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      else
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: Text(
                              "No Past Tasks",
                              style: Theme.of(context).primaryTextTheme.caption,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
