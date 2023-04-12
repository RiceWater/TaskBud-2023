import 'package:hive_flutter/hive_flutter.dart';

class TagDatabase {
  final _tagBox = Hive.box('boxForTags');
  static int _counter = 0;
  int id = 0;

  List<String> existingTags = [];

  void createInitialTagData() {
    existingTags = ['No Tag', 'Personal', 'Business'];
  }

  void loadTagData() {
    existingTags = _tagBox.get('TAGS');
  }

  void updateTagDataBase() {
    _tagBox.put('TAGS', existingTags);
  }
}
