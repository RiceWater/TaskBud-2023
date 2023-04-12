import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tasks_making_page.dart';
import 'tasks_editing_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../databases/task_database.dart';

class Task {
  String taskTitle;
  String taskContent;
  DateTime taskDeadline;
  bool isDone = false;
  bool isExpanded = false;

  Task(
      {required this.taskTitle,
      required this.taskContent,
      required this.taskDeadline,
      this.isDone = false});
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> createdTasks = [];
  TextEditingController taskMessageController = TextEditingController();
  //OverlayEntry? overlayEntry = null;

  // Get the tasks due today and not complete
  List<Task> get todayTasks {
    DateTime today = DateTime.now();
    return createdTasks
        .where((task) =>
            task.taskDeadline.year == today.year &&
            task.taskDeadline.month == today.month &&
            task.taskDeadline.day == today.day &&
            task.isDone == false)
        .toList();
  }

  // Get the tasks due next week and not complete
  List<Task> get nextWeekTasks {
    DateTime today = DateTime.now();
    DateTime nextWeek = today.add(const Duration(days: 7));
    return createdTasks
        .where((task) =>
            task.taskDeadline.isAfter(today) &&
            task.taskDeadline.isBefore(nextWeek) &&
            task.isDone == false)
        .toList();
  }

  // Get the tasks due after next week and not complete
  List<Task> get soonTasks {
    DateTime today = DateTime.now();
    DateTime nextWeek = today.add(const Duration(days: 7));
    return createdTasks
        .where((task) =>
            task.taskDeadline.isAfter(nextWeek) && task.isDone == false)
        .toList();
  }

  // Get the task that are done
  List<Task> get doneTask {
    return createdTasks.where((task) => task.isDone == true).toList();
  }

  // Toggle the checkbox
  void toggleTaskIsDone(int index) {
    setState(() {
      createdTasks[index].isDone = !createdTasks[index].isDone;
    });
  }
  /*
  @override
  void initState() {
    super.initState();
    //loadTasks();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildTaskList("Today", todayTasks),
          _buildTaskList("Next Week", nextWeekTasks),
          _buildTaskList("Soon", soonTasks),
          _buildTaskList("Done", doneTask)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _awaitReturnTaskFromTaskMakingScreen(context);
        },
        /*
        onPressed: () {
          taskMessageController.text = '';
          selectedDate = DateTime.now();
          selectedTime = TimeOfDay.now();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('New Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: taskMessageController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ListTile(
                      title: const Text('Date'),
                      subtitle: Text(DateFormat.yMMMd().format(selectedDate)),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Time'),
                      subtitle: Text(selectedTime.format(context)),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Trigger Task'),
                      subtitle: const Text('Select how to trigger task'),
                      onTap: () async {
                        final trigger = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text('Select Trigger'),
                              children: <Widget>[
                                SimpleDialogOption(
                                  onPressed: () =>
                                      Navigator.of(context).pop('date'),
                                  child: const Text('On Date'),
                                ),
                                SimpleDialogOption(
                                  onPressed: () =>
                                      Navigator.of(context).pop('time'),
                                  child: const Text('On Specific Times'),
                                ),
                              ],
                            );
                          },
                        );
                        if (trigger == 'date') {
                          setState(() {
                            final task = Task(
                              taskTitle: taskMessageController.text,
                              taskDeadline: DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              ),
                            );
                            tasks.add(task);
                            saveTasks();
                            _showOverlay(task);
                          });
                          Navigator.of(context).pop();
                        } else if (trigger == 'time') {
                          // TODO: Add time-based reminder functionality
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        */
      ),
    );
  }

  //CREATE Task
  void _awaitReturnTaskFromTaskMakingScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final List<String> result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskMakingScreen(),
            )) ??
        List.filled(3, '');

    if (result[0].isEmpty && result[1].isEmpty && result[2].isEmpty) {
      return;
    }

    Task tmpTask = Task(
        taskTitle: result[0],
        taskContent: result[1],
        taskDeadline: DateFormat("hh:mm a dd-MM-yyyy").parse(result[2]));

    setState(() {
      createdTasks = [...createdTasks, tmpTask];
    });
  }

  //EDIT Task
  void _awaitReturnValueFromNoteEditingScreen(
      BuildContext context, Task taskDetails, int index) async {
    // start the SecondScreen and wait for it to finish with a result
    final List<String> result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskEditingScreen(
            taskDetails: [
              taskDetails.taskTitle,
              taskDetails.taskContent,
              DateFormat("hh:mm a dd-MM-yyyy").format(taskDetails.taskDeadline),
              // taskDetails.isDone,
            ],
          ),
        ));

    String deleteValue =
        'delete-31415926535delete-31415926535delete-31415926535';
    //DateTime deleteValueDate = DateTime.now().subtract(const Duration(days: 736570));

    if (result[0] == deleteValue &&
        result[1] == deleteValue &&
        result[2] == deleteValue) {
      for (var i in createdTasks) {
        if (i == taskDetails) {
          createdTasks.remove(i);
          break;
        }
      }

      setState(() {
        createdTasks = [...createdTasks];
      });
      return;
    }
    Task editedTask = Task(
        taskTitle: result[0],
        taskContent: result[1],
        taskDeadline: DateFormat("hh:mm a dd-MM-yyyy").parse(result[2]));

    for (var i in createdTasks) {
      if (i == taskDetails) {
        createdTasks.remove(i);
        break;
      }
    }

    setState(() {
      createdTasks = [...createdTasks, editedTask];
    });
  }

  // Make catergory
  Widget _buildTaskList(String title, List<Task> taskList) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            taskList[index].isExpanded = !isExpanded;
          });
        },
        children: taskList.map<ExpansionPanel>((Task task) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      task.isExpanded = !task.isExpanded;
                    });
                  },
                  child: ListTile(
                    title:
                        Text(title + ' (' + taskList.length.toString() + ')'),
                  ));
            },
            body: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskList.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = taskList[index];
                return InkWell(
                    child: Dismissible(
                  key: UniqueKey(),
                  child: CheckboxListTile(
                    title: GestureDetector(
                        onTap: () {
                          _awaitReturnValueFromNoteEditingScreen(
                              context, task, index);
                        },
                        child: Text(task.taskTitle)),
                    subtitle: Text(
                        DateFormat.yMMMd().add_jm().format(task.taskDeadline)),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: task.isDone,
                    onChanged: (bool? value) {
                      toggleTaskIsDone(createdTasks.indexOf(task));
                    },
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      createdTasks.removeAt(index);
                    });
                  },
                ));
              },
            ),
            isExpanded: task.isExpanded,
          );
        }).toList(),
      ),
    );
  }

  /*
  void _showOverlay(Task task) {
    if (overlayEntry != null) {
      overlayEntry!.remove();
    }
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: 0,
        right: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 150),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.taskTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat.yMMMd().add_jm().format(task.taskDeadline),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    });
    Overlay.of(context)!.insert(overlayEntry!);
    Future.delayed(const Duration(seconds: 5)).then((_) {
      if (overlayEntry != null) {
        overlayEntry!.remove();
        overlayEntry = null;
      }
    });
  }
  */
}
