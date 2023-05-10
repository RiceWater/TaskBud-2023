import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../databases/task_database.dart';

class TaskEditingScreen extends StatefulWidget {
  // late List<String> taskDetails; //indices: 0 = title, 1 = content, 2 = deadline
  int idToEdit;

  TaskEditingScreen({required this.idToEdit, super.key});

  @override
  _TaskEditingScreenState createState() => _TaskEditingScreenState();
}

class _TaskEditingScreenState extends State<TaskEditingScreen> {
  final _taskBox = Hive.box('boxForTasks');
  final TaskDatabase _taskDatabase = TaskDatabase();
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskContentController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int taskIndex = 0;

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
    loadTaskEdits();

    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xffFEFBEA),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xffe3cc9c),
              foregroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    saveTaskEdits();
                  });
                  _verifyAndSendEditedTaskBack(context);
                },
              ),
              title: Row(
                children: [
                  const Text('Edit Task',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        deleteTask();
                      },
                      icon: const Icon(Icons.delete)),
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
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: taskContentController,
                      minLines:
                          (MediaQuery.of(context).size.height.round() / 100 * 2)
                              .toInt(),
                      maxLines:
                          (MediaQuery.of(context).size.height.round() / 100 * 3)
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
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            //print(picked);
                            selectedDate = picked;
                            selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute);
                            _taskDatabase.existingTasks[taskIndex]
                                .taskDeadline = selectedDate;
                            // widget.taskDetails[2] = DateFormat("hh:mm a dd-MM-yyyy").format(selectedDate);
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
                            selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute);
                            _taskDatabase.existingTasks[taskIndex]
                                .taskDeadline = selectedDate;
                            // widget.taskDetails[2] = DateFormat("hh:mm a dd-MM-yyyy").format(selectedDate);
                          });
                        }
                      },
                    ),

                    // Padding(
                    //   padding: EdgeInsets.all(
                    //       (MediaQuery.of(context).size.height / 100 * 2)
                    //           .roundToDouble())),
                  ],
                ),
              ),
            )));
  }

  void deleteTask() {
    String deleteValue =
        'delete-31415926535delete-31415926535delete-31415926535';
    DateTime deleteValueDate =
        DateTime.now().subtract(const Duration(days: 736570));
    _taskDatabase.existingTasks[taskIndex].taskTitle = deleteValue;
    _taskDatabase.existingTasks[taskIndex].taskContent = deleteValue;
    _taskDatabase.existingTasks[taskIndex].taskDeadline = deleteValueDate;
    saveTaskEdits();
    // List<String> editedTaskData = [
    //     'delete-31415926535delete-31415926535delete-31415926535', //title
    //     'delete-31415926535delete-31415926535delete-31415926535', //content
    //     'delete-31415926535delete-31415926535delete-31415926535', //deadline
    //     //DateFormat("hh:mm a dd-MM-yyyy").format(DateTime.now().subtract(const Duration(days: 736570))), //deadline
    // ];

    Navigator.pop(context);
  }

  void _verifyAndSendEditedTaskBack(BuildContext context) {
    if (_taskDatabase.existingTasks[taskIndex].taskTitle.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Error!'),
              content: Text('Make sure to have a title!'),
            );
          });
    } else {
      // List<String> editedTaskData = [
      //   widget.taskDetails[0], //title
      //   widget.taskDetails[1], //content
      //   widget.taskDetails[2], //deadline
      // ];
      saveTaskEdits();
      Navigator.pop(context);
    }
  }

  void saveTaskEdits() {
    _taskDatabase.existingTasks[taskIndex].taskTitle = taskTitleController.text;
    _taskDatabase.existingTasks[taskIndex].taskContent =
        taskContentController.text;
    _taskDatabase.updateTaskDataBase();
    // widget.taskDetails[0] = taskTitleController.text;
    // widget.taskDetails[1] = taskContentController.text;
  }

  void loadTaskEdits() {
    for (int i = 0; i < _taskDatabase.existingTasks.length; i++) {
      if (widget.idToEdit == _taskDatabase.existingTasks[i].id) {
        taskIndex = i;
        taskTitleController.text = _taskDatabase.existingTasks[i].taskTitle;
        taskContentController.text = _taskDatabase.existingTasks[i].taskContent;
        // selectedDate = DateFormat("hh:mm a dd-MM-yyyy").parse(_taskDatabase.existingTasks[i].taskDeadline);
        selectedDate = _taskDatabase.existingTasks[i].taskDeadline;
        selectedTime = TimeOfDay.fromDateTime(selectedDate);

        break;
      }
    }
    // taskTitleController.text = widget.taskDetails[0];
    // taskContentController.text = widget.taskDetails[1];
    // selectedDate = DateFormat("hh:mm a dd-MM-yyyy").parse(widget.taskDetails[2]);
    // selectedTime = TimeOfDay.fromDateTime(selectedDate);
  }
}
