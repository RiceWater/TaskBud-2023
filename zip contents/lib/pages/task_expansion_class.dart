import 'package:hive_flutter/hive_flutter.dart';
import '../databases/task_database.dart';
import '../main.dart' show Task;

class ExpansionTaskContent {
  String taskGroup;
  int totalTaskCount = 0;
  bool isExpanded = false;
  List<Task> tasksWithSameGroup = [];

  ExpansionTaskContent(
      {required this.taskGroup, this.tasksWithSameGroup = const []});
}
