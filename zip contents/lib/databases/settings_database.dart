import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart' show SettingsContent;

class SettingsDatabase {
  final _settingsBox = Hive.box('boxForSettings');

  SettingsContent sContent = SettingsContent(
    currentEmail: 'big-D@gmail.com',
    displayName: 'Biggus Dikus',
  );

  void createInitialSettingsData() {
    sContent.enableDarkTheme = false;
    sContent.enableAppBuddy = true;
    sContent.displayName = 'Biggus Dikus';
    sContent.currentEmail = 'big-D@gmail.com';
    sContent.enableVibration = true;
  }

  void loadSettingsData() {
    sContent = _settingsBox.get('SETTINGS');
  }

  void updateSettingsDataBase() {
    _settingsBox.put('SETTINGS', sContent);
  }
}

/*
Account with name and pfp with triple dot
  - change name (Done) 
  - show email (Done)
  - delete account

Sync

General
  - Dark Theme
  - App buddy
  - Sounds
    - Change alarm sound
    - Enable/disable vibration

FAQ (To be moved by the app budy icon)
Feedback
  - rate the app
  - contact developers
About App
  - Ver No
  - Dev Info
  - Features

Sign Out
*/
