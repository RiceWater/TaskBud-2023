import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../databases/tag_database.dart';

class TagDeletingScreen extends StatefulWidget {
  const TagDeletingScreen({super.key});

  @override
  _TagDeletingScreenState createState() => _TagDeletingScreenState();
}

class _TagDeletingScreenState extends State<TagDeletingScreen> {
  final TagDatabase _tagDatabase = TagDatabase();
  late List<TagData> _tags = initializeTagData();

  @override
  void initState() {
    super.initState();
    if (_tagDatabase.existingTags.isEmpty) {
      _tagDatabase.loadTagData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: const Text('Delete Tags',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 75 / 100,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _tags.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          _tags[index].title,
                        ),
                        value: _tags[index].isSelected,
                        onChanged: (val) {
                          setState(
                            () {
                              _tags[index].isSelected = val ?? true;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      _sendNewTagSetBack(context);
                    },
                  ),
                ),
              ],
            )));
  }

  void deleteTags(BuildContext context) {
    for (int i = 0; i < _tags.length; i++) {
      if (_tags[i].isSelected == true) {
        _tags.remove(_tags[i]);
        i--; //to prevent skipping of tags
      }
    }
  }

  //To return a new list of tags
  void _sendNewTagSetBack(BuildContext context) {
    deleteTags(context);
    _tags.insert(0, TagData(isSelected: false, title: 'No Tag'));
    List<String> tagsToReturn = _tags.map((tagData) => tagData.title).toList();

    setState(() {
      _tagDatabase.existingTags = tagsToReturn;
    });
    _tagDatabase.updateTagDataBase();
    Navigator.pop(context);
  }

  List<TagData> initializeTagData() {
    List<TagData> newTagData = [];
    _tagDatabase.loadTagData();
    for (int i = 1; i < _tagDatabase.existingTags.length; i++) {
      TagData tagData =
          TagData(isSelected: false, title: _tagDatabase.existingTags[i]);
      newTagData.add(tagData);
    }

    return newTagData;
  }
}

class TagData {
  final String title;
  bool isSelected;

  TagData({required this.isSelected, required this.title});
}
