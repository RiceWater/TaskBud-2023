import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/databases/settings_database.dart';

import '/pages/settings_related/settings_sounds_page.dart';
import '/pages/settings_related/settings_account_page.dart';
import '/pages/settings_related/settings_faq_page.dart';
import '/pages/settings_related/settings_feedback_page.dart';
import '/pages/settings_related/settings_about-app_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsBox = Hive.box('boxForSettings');
  final SettingsDatabase _settingsDatabase = SettingsDatabase();
  String displayName = '';

  @override
  void initState() {
    super.initState();
    if (_settingsBox.get('SETTINGS') == null) {
      _settingsDatabase.createInitialSettingsData();
    } else {
      _settingsDatabase.loadSettingsData();
    }
    _settingsDatabase.updateSettingsDataBase();
    displayName = _settingsDatabase.sContent.displayName;
  }

  @override
  Widget build(BuildContext context) {
    _settingsDatabase.loadSettingsData();
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 2.5 / 100, 0, 0)),
          Row(children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 7.5 / 100, 0, 0, 0)),
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://picsum.photos/id/237/200/300'),
                  minRadius: 30,
                  maxRadius: 30,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 5 / 100, 0, 0, 0)),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Text(
                    displayName,
                    style: TextStyle(fontSize: 18),
                  );
                }),
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  _awaitReturnFromSettingRelatedScreen(context, 1);
                },
                icon: const Icon(Icons.more_vert)),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    0, 0, MediaQuery.of(context).size.width * 5 / 100, 0)),
          ]),
          Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 2.5 / 100, 0, 0)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 90 / 100,
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.sync),
                  horizontalTitleGap: 0,
                  title: const Text('Sync Data'),
                  onTap: () {
                    print('pressed');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                      Icons.dark_mode), // Icon widget as the leading element
                  title: Text('Dark Mode'),
                  horizontalTitleGap: 0, // Title of the ListTile
                  trailing: Switch(
                    value: _settingsDatabase
                        .sContent.enableDarkTheme, //_switchValue,
                    onChanged: (value) {
                      setState(() {
                        _settingsDatabase.sContent.enableDarkTheme = value;
                      });
                      _settingsDatabase.updateSettingsDataBase();
                      _settingsDatabase.loadSettingsData();
                    },
                  ), // Switch widget as the trailing element
                  onTap: () {
                    setState(() {
                      _settingsDatabase.sContent.enableDarkTheme =
                          !_settingsDatabase.sContent.enableDarkTheme;
                    });
                    _settingsDatabase.updateSettingsDataBase();
                    _settingsDatabase.loadSettingsData();
                  }, // Optional onTap callback
                ),
                ListTile(
                  leading: const Icon(
                      Icons.pets), // Icon widget as the leading element
                  title: const Text('App Buddy'),
                  horizontalTitleGap: 0, // Title of the ListTile
                  trailing: Switch(
                    value: _settingsDatabase
                        .sContent.enableAppBuddy, //_switchValue,
                    onChanged: (value) {
                      setState(() {
                        _settingsDatabase.sContent.enableAppBuddy = value;
                      });
                      _settingsDatabase.updateSettingsDataBase();
                      _settingsDatabase.loadSettingsData();
                    },
                  ), // Switch widget as the trailing element
                  onTap: () {
                    setState(() {
                      _settingsDatabase.sContent.enableAppBuddy =
                          !_settingsDatabase.sContent.enableAppBuddy;
                    });
                    _settingsDatabase.updateSettingsDataBase();
                    _settingsDatabase.loadSettingsData();
                  }, // Optional onTap callback
                ),
                ListTile(
                  leading: const Icon(Icons.music_note_rounded),
                  horizontalTitleGap: 0,
                  title: const Text('Sounds'),
                  onTap: () {
                    _awaitReturnFromSettingRelatedScreen(context, 2);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  horizontalTitleGap: 0,
                  title: const Text('FAQ'),
                  onTap: () {
                    _awaitReturnFromSettingRelatedScreen(context, 3);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  horizontalTitleGap: 0,
                  title: const Text('Feedback'),
                  onTap: () {
                    _awaitReturnFromSettingRelatedScreen(context, 4);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_mark_outlined),
                  horizontalTitleGap: 0,
                  title: const Text('About App'),
                  onTap: () {
                    _awaitReturnFromSettingRelatedScreen(context, 5);
                  },
                ),
                const Divider(),
                OutlinedButton(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 90 / 100,
                      height: 40,
                      child: const Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
        ],
      )),
    ));
  }

  void _awaitReturnFromSettingRelatedScreen(
      BuildContext context, int index) async {
    switch (index) {
      case 1:
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsAccountScreen(),
            ));
        setState(() {
          _settingsDatabase.loadSettingsData();
          displayName = _settingsDatabase.sContent.displayName;
        });
        break;
      case 2:
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsSoundsScreen(),
            ));
        break;
      case 3:
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsFAQScreen(),
            ));
        break;
      case 4:
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsFeedbackScreen(),
            ));
        break;
      case 5:
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsAboutAppScreen(),
            ));
        break;
      default:
        break;
    }
  }
}
