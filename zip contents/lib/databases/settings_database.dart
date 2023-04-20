import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';

class SettingsDatabase {
  final _settingsBox = Hive.box('boxForSettings');
  String accountName = '';
  String accountEmail = '';

  bool enableDarkTheme = false, enableAppBuddy = false;
  void createInitialSettingsData() {}

  void loadSettingsData() {}

  void updateSettingsDataBase() {}
}

/*
Account with name and pfp with triple dot
  - change name
  - show email
  - sign out
  - delete account

Sync

General
  - Dark Theme
  - App buddy
  - Sounds
    - Change alarm sound
    - Enable/disable vibration

FAQ
Feedback
  - rate the app
  - contact developers
About App
  - Ver No
  - Dev Info
  - Features
*/
