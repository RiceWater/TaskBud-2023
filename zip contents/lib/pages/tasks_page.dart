import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tasks_making_page.dart';
import 'tasks_editing_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../databases/task_database.dart';
import '../main.dart' show Task;
import '../pages/task_expansion_class.dart' show ExpansionTaskContent;

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController taskMessageController = TextEditingController();
  // Toggle the checkbox
  void toggleTaskIsDone(int index) {
    setState(() {
      _taskDatabase.existingTasks[index].isDone =
          !_taskDatabase.existingTasks[index].isDone;
    });
  }

  void dismissTask(int index) {
    setState(() {
      _taskDatabase.existingTasks.removeAt(index);
    });
  }

  final _taskBox = Hive.box('boxForTasks');
  final TaskDatabase _taskDatabase = TaskDatabase();
  //===============================================================================
  List<ExpansionTaskContent> expansionTasks = [
    ExpansionTaskContent(taskGroup: 'Today', tasksWithSameGroup: []),
    ExpansionTaskContent(taskGroup: 'Next Week', tasksWithSameGroup: []),
    ExpansionTaskContent(taskGroup: 'Soon', tasksWithSameGroup: []),
    ExpansionTaskContent(taskGroup: 'Done', tasksWithSameGroup: []),
  ];
  //===============================================================================
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
    _initalizeExpansionTasks();
    return Scaffold(
      body: ListView(
        children: [
          _buildTaskList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _awaitReturnTaskFromTaskMakingScreen(context);
        },
      ),
    );
  }

  //===============================================================================
  //INITALIZE expansionTasks
  void _initalizeExpansionTasks() {
    expansionTasks[0].tasksWithSameGroup = _taskDatabase.todayTasks;
    expansionTasks[1].tasksWithSameGroup = _taskDatabase.nextWeekTasks;
    expansionTasks[2].tasksWithSameGroup = _taskDatabase.soonTasks;
    expansionTasks[3].tasksWithSameGroup = _taskDatabase.doneTask;
  }

  // Make catergory
  Widget _buildTaskList() {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            expansionTasks[index].isExpanded = !isExpanded;
          });
        },
        children: expansionTasks
            .map<ExpansionPanel>((ExpansionTaskContent taskCategory) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      taskCategory.isExpanded = !taskCategory.isExpanded;
                    });
                  },
                  child: ListTile(
                    title: Text(taskCategory.taskGroup +
                        ' (' +
                        taskCategory.tasksWithSameGroup.length.toString() +
                        ')'),
                  ));
            },
            body: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskCategory.tasksWithSameGroup.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    child: Dismissible(
                  key: UniqueKey(),
                  child: CheckboxListTile(
                    title: GestureDetector(
                        onTap: () {
                          _awaitReturnValueFromNoteEditingScreen(
                              context, taskCategory.tasksWithSameGroup[index]);
                        },
                        child: Text(
                            taskCategory.tasksWithSameGroup[index].taskTitle)),
                    subtitle: Text(DateFormat.yMMMd().add_jm().format(
                        taskCategory.tasksWithSameGroup[index].taskDeadline)),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: taskCategory.tasksWithSameGroup[index].isDone,
                    onChanged: (bool? value) {
                      toggleTaskIsDone(_taskDatabase
                          .getIndex(taskCategory.tasksWithSameGroup[index]));
                    },
                  ),
                  onDismissed: (direction) {
                    dismissTask(_taskDatabase
                        .getIndex(taskCategory.tasksWithSameGroup[index]));
                  },
                ));
              },
            ),
            isExpanded: taskCategory.isExpanded,
          );
        }).toList(),
      ),
    );
  }

  //===============================================================================

  //CREATE Task
  void _awaitReturnTaskFromTaskMakingScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TaskMakingScreen(),
        ));

    if (_taskDatabase.existingTasks[_taskDatabase.existingTasks.length - 1]
                .taskTitle ==
            '' &&
        _taskDatabase.existingTasks[_taskDatabase.existingTasks.length - 1]
                .taskContent ==
            '') {
      return;
    }

    setState(() {
      _taskDatabase.loadTaskData();
    });
  }

  //EDIT Task
  void _awaitReturnValueFromNoteEditingScreen(
      BuildContext context, Task taskDetails) async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskEditingScreen(idToEdit: taskDetails.id),
        ));

    _taskDatabase.loadTaskData();
    String deleteValue =
        'delete-31415926535delete-31415926535delete-31415926535';
    DateTime deleteValueDate =
        DateTime.now().subtract(const Duration(days: 736570));

    setState(() {
      if (taskDetails.taskTitle == deleteValue &&
          taskDetails.taskContent == deleteValue &&
          taskDetails.taskDeadline == deleteValueDate) {
        for (var i in _taskDatabase.existingTasks) {
          if (i.id == taskDetails.id) {
            _taskDatabase.existingTasks.remove(i);
            //_taskDatabase.updateNoteDataBase();
          }
        }
        //_taskDatabase.removeTask(taskDetails.id);
      }
    });
  }

  // // Make catergory
  // Widget _buildTaskList(String title, List<Task> taskList) {
  //   return SingleChildScrollView(
  //     child: ExpansionPanelList(
  //       expansionCallback: (int index, bool isExpanded) {
  //         setState(() {
  //           taskList[index].isExpanded = !isExpanded;
  //         });
  //       },
  //       children: taskList.map<ExpansionPanel>((Task task) {
  //         return ExpansionPanel(
  //           headerBuilder: (BuildContext context, bool isExpanded) {
  //             return GestureDetector(
  //                 onTap: () {
  //                   setState(() {
  //                     task.isExpanded = !task.isExpanded;
  //                   });
  //                 },
  //                 child: ListTile(
  //                   title:
  //                       Text(title + ' (' + taskList.length.toString() + ')'),
  //                 ));
  //           },
  //           body: ListView.builder(
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: taskList.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return InkWell(
  //                   child: Dismissible(
  //                 key: UniqueKey(),
  //                 child: CheckboxListTile(
  //                   title: GestureDetector(
  //                       onTap: () {
  //                         _awaitReturnValueFromNoteEditingScreen(context, task);
  //                       },
  //                       child: Text(task.taskTitle)),
  //                   subtitle: Text(
  //                       DateFormat.yMMMd().add_jm().format(task.taskDeadline)),
  //                   controlAffinity: ListTileControlAffinity.leading,
  //                   value: task.isDone,
  //                   onChanged: (bool? value) {
  //                     toggleTaskIsDone(_taskDatabase.getIndex(task));
  //                   },
  //                 ),
  //                 onDismissed: (direction) {
  //                   dismissTask(_taskDatabase.getIndex(task));
  //                 },
  //               ));
  //             },
  //           ),
  //           isExpanded: task.isExpanded,
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
}
