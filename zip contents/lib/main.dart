import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:notetaking/pages/log_in_page.dart';
import '/databases/settings_database.dart';
import '/databases/task_database.dart';

import 'pages/home_page.dart';
import 'pages/notes_page.dart';
import 'pages/tasks_page.dart';
import 'pages/settings_page.dart';
import 'pages/splash_page.dart';
import 'pages/app-buddy_faq_page.dart';
import 'services/notif_service.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SettingsContentAdapter());
  await Hive.openBox('boxForTags');
  await Hive.openBox('boxForNotes');
  await Hive.openBox('boxForTasks');
  await Hive.openBox('boxForSettings');

  //====================================
  //To reset when debugging/testing
  // final _tagBox = Hive.box('boxForTags');
  // final _noteBox = Hive.box('boxForNotes');
  // final _taskBox = Hive.box('boxForTasks');
  // final _settingsBox = Hive.box('boxForSettings');
  // _tagBox.clear();
  // _noteBox.clear();
  // _taskBox.clear();
  // _settingsBox.clear();
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
        primarySwatch: Colors.grey,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent),
      ),
      home: const SplashScreen(),
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
  late Icon currentIcon; // = Icon(Icons.home_outlined)
  final _settingsBox = Hive.box('boxForSettings');
  final _settingsDatabase = SettingsDatabase();
  final _taskBox = Hive.box('boxForTasks');
  final TaskDatabase _taskDatabase = TaskDatabase();

  @override
  void initState() {
    super.initState();
    if (_settingsBox.get('SETTINGS') == null) {
      _settingsDatabase.createInitialSettingsData();
    } else {
      _settingsDatabase.loadSettingsData();
    }
    _settingsDatabase.updateSettingsDataBase();

    if (_taskBox.get('TASKS') == null) {
      _taskDatabase.createInitialTaskData();
    } else {
      _taskDatabase.loadTaskData();
    }
    _taskDatabase.updateTaskDataBase();
  }

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
        screenName = "Home";
        page = const HomeScreen();
        break;
    }
    NotificationService nService = NotificationService();
    String todTasks = '';
    for (int i = 0; i < _taskDatabase.todayTasks.length; i++) {
      todTasks += _taskDatabase.todayTasks[i].taskTitle + "\n";
    }
    nService.scheduleNotification('Today\'s Tasks', todTasks);
    return SafeArea(
      child: Theme(
        data: (_settingsDatabase.sContent.enableDarkTheme)
            ? ThemeData.dark()
            : ThemeData.light(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xffe3cc9c), //upper bar
            //foregroundColor: Colors.black,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        _awaitReturnFromAppBuddyFAQScreen(context);
                      },
                      icon: const ImageIcon(
                        AssetImage('assets/images/taskbud_filled.png'),
                        //size: 40,
                      ),
                      iconSize: 40),
                  //currentIcon,
                  const Padding(padding: EdgeInsets.all(5)),
                  Text(screenName),
                ]),
          ),
          body: Center(child: page),
          bottomNavigationBar: appNavBar(),
        ),
      ),
    );
  }

  BottomNavigationBar appNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting, // Shifting
      selectedItemColor: (_settingsDatabase.sContent.enableDarkTheme)
          ? const Color(0xff000000)
          : const Color(0xff000000),
      unselectedItemColor: const Color(0xffEFEFEF),

      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Color(0xffe3cc9c), //buttomnavbarCOLOR
          //backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons
              .pencil_circle_fill), //Icon(Icons.note_add_rounded),
          label: 'Notes',
          backgroundColor: Color(0xffe3cc9c),
          //backgroundColor: Color(0xff00335d),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.alarm_fill), //Icon(Icons.alarm),
          label: 'Tasks',
          backgroundColor: Color(0xffe3cc9c),
          //backgroundColor: Color(0xff374755),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.gear_solid), //Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: Color(0xffe3cc9c),
          //backgroundColor: Color(0xff777777),
        ),
      ],
    );
  }

  void _awaitReturnFromAppBuddyFAQScreen(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AppBuddyFAQScreen(),
        ));
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

class SettingsContent {
  bool enableDarkTheme = false, enableAppBuddy = true;
  String displayName = ''; //To change to email after google and firebase
  String currentEmail = '';
  bool enableVibration = true;

  SettingsContent({
    this.enableDarkTheme = false,
    this.enableAppBuddy = true,
    this.displayName = '',
    this.currentEmail = '',
    this.enableVibration = true,
  });
}

class SettingsContentAdapter extends TypeAdapter<SettingsContent> {
  @override
  final typeId = 42; //each adapter must have unique typeId (0 - 200)

  @override
  SettingsContent read(BinaryReader reader) {
    final enableDarkTheme = reader.read() as bool;
    final enableAppBuddy = reader.read() as bool;
    final displayName = reader.read() as String;
    final currentEmail = reader.read() as String;
    final enableVibration = reader.read() as bool;
    return SettingsContent(
        enableDarkTheme: enableDarkTheme,
        enableAppBuddy: enableAppBuddy,
        displayName: displayName,
        currentEmail: currentEmail,
        enableVibration: enableVibration);
  }

  @override
  void write(BinaryWriter writer, SettingsContent obj) {
    writer.write(obj.enableDarkTheme);
    writer.write(obj.enableAppBuddy);
    writer.write(obj.displayName);
    writer.write(obj.currentEmail);
    writer.write(obj.enableVibration);
  }
}
