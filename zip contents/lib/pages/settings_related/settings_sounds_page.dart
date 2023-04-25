import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/databases/settings_database.dart';

class SettingsSoundsScreen extends StatefulWidget {
  const SettingsSoundsScreen({super.key});

  @override
  _SettingsSoundsScreenState createState() => _SettingsSoundsScreenState();
}

class _SettingsSoundsScreenState extends State<SettingsSoundsScreen> {

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
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: const Text('Sounds'),
        ),
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 2.5 / 100, 0, 0)),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 90/100,
                  child: Column(children: [
                    ListTile(
                      leading: const Icon(Icons.pets), // Icon widget as the leading element
                      title: const Text('Vibration'),
                      horizontalTitleGap: 0, // Title of the ListTile
                      trailing: Switch(
                        value: _settingsDatabase.sContent.enableVibration, //_switchValue,
                        onChanged: (value) {
                          setState(() {
                            _settingsDatabase.sContent.enableVibration = value;
                          });
                          _settingsDatabase.updateSettingsDataBase();
                          _settingsDatabase.loadSettingsData();
                        },
                      ), // Switch widget as the trailing element
                      onTap: () {
                        setState(() {
                          _settingsDatabase.sContent.enableVibration = !_settingsDatabase.sContent.enableVibration;
                        });
                        _settingsDatabase.updateSettingsDataBase();
                        _settingsDatabase.loadSettingsData();
                      }, // Optional onTap callback
                    ),
                    ListTile(
                      leading: const Icon(Icons.music_note_rounded),
                      horizontalTitleGap: 0,
                      title: const Text('Change Alarm Sound'),
                      onTap: () {
                        //_awaitReturnNoteFromNoteMakingScreen(context);
                        print('pressed');
                      },
                    ),
                  ]),
                ),
              )
            ],
          )
        ),
      )
    );
  }

}