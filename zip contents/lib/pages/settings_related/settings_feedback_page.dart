//TODO: Add mailing feature. Cannot implement as of Apr 24 due to potential vulnerabilities of the mailing system
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/databases/settings_database.dart';

class SettingsFeedbackScreen extends StatefulWidget {
  const SettingsFeedbackScreen({super.key});

  @override
  _SettingsFeedbackScreenState createState() => _SettingsFeedbackScreenState();
}

class _SettingsFeedbackScreenState extends State<SettingsFeedbackScreen> {
  final _settingsBox = Hive.box('boxForSettings');
  final SettingsDatabase _settingsDatabase = SettingsDatabase();

  final TextEditingController _displayEmailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
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
    _displayEmailController.text = "To: ccs@gbox.adnu.edu.ph";
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
                  const Text('Feedback',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            body: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 90 / 100,
                  child: Column(
                    children: [
                      TextField(
                        readOnly: true,
                        controller: _displayEmailController,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                      TextField(
                        controller: _subjectController,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          hintText: "Subject",
                        ),
                      ),
                      TextField(
                        controller: _bodyController,
                        minLines: (MediaQuery.of(context).size.height.round() /
                                    100 *
                                    3)
                                .toInt() -
                            4,
                        maxLines: (MediaQuery.of(context).size.height.round() /
                                    100 *
                                    3)
                                .toInt() -
                            4,
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          hintText: "Put your feedback here",
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      OutlinedButton(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 90 / 100,
                            height: 40,
                            child: const Center(
                              child: Text(
                                'Send Feedback',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onPressed: () {}),
                      const Padding(padding: EdgeInsets.all(5)),
                      OutlinedButton(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 90 / 100,
                            height: 40,
                            child: const Center(
                              child: Text(
                                'Rate on App Store',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onPressed: () {}),
                    ],
                  ),
                ),
              ),
            )));
  }
}
