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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
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
                        children: <Widget>[
                          ListTile(
                            horizontalTitleGap: 0,
                            title: const Text('App Name'),
                            trailing: const Text('TaskBud'),
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          ListTile(
                            horizontalTitleGap: 0,
                            title: const Text('Version No.'),
                            trailing: const Text('1.0.0'),
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          ListTile(
                            horizontalTitleGap: 0,
                            title: const Text('Company'),
                            trailing: const Text('Ateneo de Naga University'),
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          ListTile(
                            horizontalTitleGap: 0,
                            title: const Text('Release Date'),
                            trailing: const Text('May 20, 2023'),
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
