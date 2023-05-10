import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/databases/settings_database.dart';

class SettingsAboutAppScreen extends StatefulWidget {
  const SettingsAboutAppScreen({super.key});

  @override
  _SettingsAboutAppScreenState createState() => _SettingsAboutAppScreenState();
}

class _SettingsAboutAppScreenState extends State<SettingsAboutAppScreen> {
  final _settingsBox = Hive.box('boxForSettings');
  final SettingsDatabase _settingsDatabase = SettingsDatabase();

  @override
  void initState() {
    super.initState();
    if (_settingsBox.get('SETTINGS') == null) {
      _settingsDatabase.createInitialSettingsData();
    } else {
      _settingsDatabase.loadSettingsData();
    }
    _settingsDatabase.updateSettingsDataBase();
  }

  @override
  Widget build(BuildContext context) {
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
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              title: Row(
                children: [
                  const Text('About App',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 90 / 100,
                      child: Column(
                        children: const <Widget>[
                          ListTile(
                            horizontalTitleGap: 0,
                            title: Text('App Name'),
                            trailing: Text('TaskBud'),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          ListTile(
                            horizontalTitleGap: 0,
                            title: Text('Version No.'),
                            trailing: Text('1.0.0'),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          ListTile(
                            horizontalTitleGap: 0,
                            title: Text('Company'),
                            trailing: Text('Ateneo de Naga University'),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          ListTile(
                            horizontalTitleGap: 0,
                            title: Text('Release Date'),
                            trailing: Text('May 20, 2023'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
