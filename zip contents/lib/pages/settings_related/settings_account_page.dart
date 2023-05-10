import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/databases/settings_database.dart';

class SettingsAccountScreen extends StatefulWidget {
  const SettingsAccountScreen({super.key});

  @override
  _SettingsAccountScreenState createState() => _SettingsAccountScreenState();
}

class _SettingsAccountScreenState extends State<SettingsAccountScreen> {
  final _settingsBox = Hive.box('boxForSettings');
  final SettingsDatabase _settingsDatabase = SettingsDatabase();
  final TextEditingController _displayNameController = TextEditingController();
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
      backgroundColor: Color(0xffFEFBEA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffe3cc9c),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _settingsDatabase.updateSettingsDataBase();
            });
            Navigator.pop(context);
            //Navigator.pop(context, name);
          },
        ),
        title: Row(
          children: [
            const Text('Account',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
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
              width: MediaQuery.of(context).size.width * 90 / 100,
              child: Column(children: [
                ListTile(
                  title: const Text('Email Address'),
                  horizontalTitleGap: 0, // Title of the ListTile
                  trailing: Text(_settingsDatabase.sContent
                      .currentEmail), // Switch widget as the trailing element
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  title: const Text('Display Name'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => createNewDisplayName(context));
                  },
                  trailing: Text(_settingsDatabase.sContent.displayName),
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  title: const Text('Delete Account'),
                  onTap: () {},
                ),
              ]),
            ),
          )
        ],
      )),
    ));
  }

  AlertDialog createNewDisplayName(BuildContext context) {
    return AlertDialog(
        content: SizedBox(
      height: 100,
      child: Column(
        children: <Widget>[
          TextField(
            controller: _displayNameController,
            decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              hintText: 'New Display Name',
            ),
          ),
          const Padding(padding: EdgeInsets.fromLTRB(0, 10, 10, 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              OutlinedButton(
                  onPressed: () {
                    if (_displayNameController.text.trim().length < 2) {
                      null;
                    } else {
                      setState(() {
                        _settingsDatabase.sContent.displayName =
                            _displayNameController.text;
                        //name = _displayNameController.text;
                      });
                      _settingsDatabase.updateSettingsDataBase();
                      _settingsDatabase.loadSettingsData();
                      _displayNameController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save')),
            ],
          )
        ],
      ),
    ));
    //     },
    //   ),
    // );
  }
}
