import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class TaskDatabase {
  final _taskBox = Hive.box('boxForTasks');
  List<Task> existingTasks = [];
  List<Task> existingTodayTasks = [];
  List<Task> existingNextWeekTasks =
      []; //dont mind me just wanna try something hahaha

  void createInitialTaskData() {
    existingTasks = [
      Task(
          taskTitle: 'Task 1',
          taskContent: 'A text',
          taskDeadline: DateTime.now(),
          isDone: false),
      Task(
          taskTitle: 'Task 2',
          taskContent: '',
          taskDeadline: DateTime.now().add(Duration(days: 7)),
          isDone: false),
      Task(
          taskTitle: 'Task 3',
          taskContent: 'Nothing to see here',
          taskDeadline: DateTime.now().add(Duration(days: 14)),
          isDone: false),
      Task(
          taskTitle: 'Task 4',
          taskContent: 'Task is done',
          taskDeadline: DateTime.now().add(Duration(days: 14)),
          isDone: true),
    ];
  }

  void loadTaskData() {
    existingTasks = _taskBox.get('TASKS');
  }

  void updateTaskDataBase() {
    _taskBox.put('TASKS', existingTasks);
  }

  void setNewTask(String taskTitle, String taskContent, DateTime taskDeadline) {
    Task newTask = Task(
        taskTitle: taskTitle,
        taskContent: taskContent,
        taskDeadline: taskDeadline);
    existingTasks.add(newTask);
  }

  void removeTask(int index) {
    _taskBox.deleteAt(index);
  }

  List<String> provideTaskDetails(i) {
    List<String> taskDetails = [
      existingTasks[i].taskTitle,
      existingTasks[i].taskContent,
      DateFormat("hh:mm a dd-MM-yyyy").format(existingTasks[i].taskDeadline),
      existingTasks[i].isDone.toString(),
      existingTasks[i].id.toString(),
    ];
    return taskDetails;
  }

  // List<dynamic> getTodayTasks() {
  //   return todayTasks;
  // }

  //Get the tasks due today and not complete
  void initializeTodayTasks() {
    existingTodayTasks.clear();
    DateTime today = DateTime.now();
    for (var i in existingTasks) {
      if (i.taskDeadline.year == today.year &&
          i.taskDeadline.month == today.month &&
          i.taskDeadline.day == today.day &&
          i.isDone == false) {
        existingTodayTasks.add(i);
      }
    }
  }

  // //Get the tasks due today and not complete
  // List<Task> get todayTasks {
  //   DateTime today = DateTime.now();
  //   return existingTasks
  //       .where((task) =>
  //           task.taskDeadline.year == today.year &&
  //           task.taskDeadline.month == today.month &&
  //           task.taskDeadline.day == today.day &&
  //           task.isDone == false)
  //       .toList();
  // }

  // Get the tasks due next week and not complete
  List<Task> get nextWeekTasks {
    DateTime today = DateTime.now();
    DateTime nextWeek = today.add(const Duration(days: 7));
    return existingTasks
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
    return existingTasks
        .where((task) =>
            task.taskDeadline.isAfter(nextWeek) && task.isDone == false)
        .toList();
  }

  // Get the task that are done
  List<Task> get doneTask {
    return existingTasks.where((task) => task.isDone == true).toList();
  }
}
