import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../databases/task_database.dart';
import '../main.dart' show Task;

class TaskMakingScreen extends StatefulWidget {
  const TaskMakingScreen({super.key});

  @override
  _TaskMakingScreenState createState() => _TaskMakingScreenState();
}

class _TaskMakingScreenState extends State<TaskMakingScreen> {
  final _taskBox = Hive.box('boxForTasks');
  final TaskDatabase _taskDatabase = TaskDatabase();
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskContentController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Task newTask =
      Task(taskTitle: '', taskContent: '', taskDeadline: DateTime.now());
  @override
  void initState() {
    if (_taskBox.get('TASKS') == null) {
      _taskDatabase.createInitialTaskData();
    } else {
      _taskDatabase.loadTaskData();
    }
    _taskDatabase.updateTaskDataBase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text('New Task', style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * (3 / 100),
              MediaQuery.of(context).size.height * (2 / 100),
              MediaQuery.of(context).size.width * (3 / 100),
              MediaQuery.of(context).size.height * (2 / 100)),
          child: Column(
            children: <Widget>[
              TextField(
                controller: taskTitleController,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Task\'s Title',
                  enabledBorder: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: taskContentController,
                minLines: (MediaQuery.of(context).size.height.round() / 100 * 2)
                    .toInt(),
                maxLines: (MediaQuery.of(context).size.height.round() / 100 * 3)
                    .toInt(),
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Input description here',
                  enabledBorder: InputBorder.none,
                ),
              ),
              ListTile(
                title: const Text('Date'),
                subtitle: Text(DateFormat.yMMMd().format(selectedDate)),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
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
              Padding(
                  padding: EdgeInsets.all(
                      (MediaQuery.of(context).size.height / 100 * 2)
                          .roundToDouble())),
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
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
                ],
              ),
              */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      setState(() {
                        newTask.taskContent = taskContentController.text;
                        newTask.taskTitle = taskTitleController.text;
                        newTask.taskDeadline = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute);
                      });

                      _verifyAndSendTaskBack(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _verifyAndSendTaskBack(BuildContext context) {
    if (newTask.taskTitle.isEmpty || newTask.taskContent.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Error!'),
              content: Text('Make sure to fill up everything!'),
            );
          });
    } else {
      // List<String> taskData = [
      //   newTask.taskTitle,
      //   newTask.taskContent,
      //   DateFormat("hh:mm a dd-MM-yyyy").format(newTask.taskDeadline),
      // ];
      _taskDatabase.setNewTask(
          newTask.taskTitle, newTask.taskContent, newTask.taskDeadline);
      _taskDatabase.updateTaskDataBase();
      // print(taskData);
      Navigator.pop(context);
    }
  }
}

// class Task {
//   String taskTitle;
//   String taskContent;
//   DateTime taskDeadline;
//   bool isDone = false;

//   Task(
//       {required this.taskTitle,
//       required this.taskContent,
//       required this.taskDeadline,
//       this.isDone = false});
// }
