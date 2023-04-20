import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/home_page.dart';
import 'pages/notes_page.dart';
import 'pages/tasks_page.dart';
import 'pages/settings_page.dart';
import 'pages/splash_page.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox('boxForTags');
  await Hive.openBox('boxForNotes');
  await Hive.openBox('boxForTasks');

  //====================================
  //To reset when debugging/testing
  final _tagBox = Hive.box('boxForTags');
  final _noteBox = Hive.box('boxForNotes');
  final _taskBox = Hive.box('boxForTasks');
  _tagBox.clear();
  _noteBox.clear();
  _taskBox.clear();
  //====================================

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskBud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent),
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String screenName = "Home";

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        screenName = "Home";
        page = const HomeScreen();
        break;
      case 1:
        screenName = "Notes";
        page = const NoteScreen();
        break;
      case 2:
        screenName = "Tasks";
        page = const TaskScreen();
        break;
      case 3:
        screenName = "Settings";
        page = const SettingsScreen();
        break;
      default:
        page = const HomeScreen();
        break;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.access_alarms_sharp, size: 40),
                const Padding(padding: EdgeInsets.all(5)),
                Text(screenName),
              ]),
        ),
        body: Center(child: page),
        bottomNavigationBar: appNavBar(),
      ),
    );
  }

  BottomNavigationBar appNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting, // Shifting
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,

      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          //backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note_add_rounded),
          label: 'Notes',
          //backgroundColor: Color(0xff00335d),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'Tasks',
          //backgroundColor: Color(0xff374755),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
          //backgroundColor: Color(0xff777777),
        ),
      ],
    );
  }
}

//Note and NoteAdapter classes are needed to make your hive thing accept that "datatype"
class Note {
  static int _noteCounter = 0;
  int id = 0;
  String noteTitle, noteContent, tagName;

  Note(
      {required this.noteTitle,
      required this.noteContent,
      required this.tagName}) {
    if (_noteCounter >= 200000) {
      //what are the odds for the user to have more than 150000 notes?
      _noteCounter = 0;
    }
    _noteCounter++;
    id = _noteCounter;
  }
}

//typeadapter<T> is needed by Hive
class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 40; //each adapter must have unique typeId (0 - 200)

  @override
  Note read(BinaryReader reader) {
    final noteTitle = reader.read() as String;
    final noteContent = reader.read() as String;
    final tagName = reader.read() as String;
    return Note(
        noteTitle: noteTitle, noteContent: noteContent, tagName: tagName);
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.noteTitle);
    writer.write(obj.noteContent);
    writer.write(obj.tagName);
  }
}

class Task {
  static int _taskCounter = 0;
  int id = 0;
  String taskTitle;
  String taskContent;
  DateTime taskDeadline;
  bool isDone = false;
  bool isExpanded = false;

  Task(
      {required this.taskTitle,
      required this.taskContent,
      required this.taskDeadline,
      this.isDone = false}) {
    if (_taskCounter >= 200000) {
      //what are the odds for the user to have more than 150000 tasks?
      _taskCounter = 0;
    }
    _taskCounter++;
    id = _taskCounter;
  }
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 41; //each adapter must have unique typeId (0 - 200)

  @override
  Task read(BinaryReader reader) {
    final taskTitle = reader.read() as String;
    final taskContent = reader.read() as String;
    final taskDeadline = reader.read() as DateTime;
    final isDone = reader.read() as bool;
    return Task(
        taskTitle: taskTitle,
        taskContent: taskContent,
        taskDeadline: taskDeadline,
        isDone: isDone);
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.write(obj.taskTitle);
    writer.write(obj.taskContent);
    writer.write(obj.taskDeadline);
    writer.write(obj.isDone);
  }
}
