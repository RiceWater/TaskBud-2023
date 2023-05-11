import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class TaskDatabase {
  final _taskBox = Hive.box('boxForTasks');
  List<Task> existingTasks = [];
  // List<Task> todayTasks = [];
  // List<Task> nextWeekTasks = []; //dont mind me just wanna try something hahaha

  // List<Task> existingTodayTask = [];

  void createInitialTaskData() {
    existingTasks = [
      Task(
          taskTitle: 'Task 1',
          taskContent: 'A text',
          taskDeadline: DateTime.now(),
          isDone: false),
      Task(
          taskTitle: 'Task 1.1',
          taskContent: 'A text',
          taskDeadline: DateTime.now(),
          isDone: false),
      Task(
          taskTitle: 'Task 2',
          taskContent: '',
          taskDeadline: DateTime.now().add(const Duration(days: 7)),
          isDone: false),
      Task(
          taskTitle: 'Task 3',
          taskContent: 'Nothing to see here',
          taskDeadline: DateTime.now().add(const Duration(days: 14)),
          isDone: false),
      Task(
          taskTitle: 'Task 4',
          taskContent: 'Task is done',
          taskDeadline: DateTime.now().add(const Duration(days: 14)),
          isDone: true),
    ];
  }

  void loadTaskData() {
    // List<dynamic> dyn = _taskBox.get('TASKS');
    // existingTasks = dyn
    //     .map((element) => MyObject(id: element['id'], name: element['name']))
    //     .toList();
    existingTasks = _taskBox.get('TASKS').cast<Task>();
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

  void toggleTaskIsDone(int index) {
    existingTasks[index].isDone = !existingTasks[index].isDone;
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
  //
  int getIndex(Task thistask) {
    int index = 0;

    for (var task in existingTasks) {
      if (task.taskDeadline.year == thistask.taskDeadline.year &&
          task.taskDeadline.month == thistask.taskDeadline.month &&
          task.taskDeadline.day == thistask.taskDeadline.day &&
          task.taskDeadline.hour == thistask.taskDeadline.hour) {
        return index;
      }
      index++;
    }
    return index;
  }

  List<Task> get todayTasks {
    DateTime today = DateTime.now();
    return existingTasks
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
