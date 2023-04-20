import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'tag_deleting_page.dart';
import '../databases/tag_database.dart';

class TagMakingScreen extends StatefulWidget {
  const TagMakingScreen({super.key});

  @override
  _TagMakingScreenState createState() => _TagMakingScreenState();
}

class _TagMakingScreenState extends State<TagMakingScreen> {
  final _tagBox = Hive.box('boxForTags');
  final TagDatabase _tagDatabase = TagDatabase();

  String selectedTagName = 'No Tag';
  TextEditingController tagNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_tagBox.get('TAGS') == null) {
      _tagDatabase.createInitialTagData();
    } else {
      _tagDatabase.loadTagData();
    }
    _tagDatabase.updateTagDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Row(
            children: <Widget>[
              const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => createNewTag(context));
                    //_awaitReturnValueFromTagMakingScreen(context);
                  },
                  icon: const Icon(Icons.add)),
              const Padding(padding: EdgeInsets.all(5)),
              IconButton(
                  onPressed: () {
                    _awaitReturnValueFromTagDeletingScreen(context);
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 10.0, // gap between lines,
            children: //[
                generateNoteTags().toList(),
          ),
        ),
      ),
    );
  }

  void _sendTagNameBack(BuildContext context) {
    String tagToReturn = selectedTagName;
    Navigator.pop(context, tagToReturn);
  }

  void _awaitReturnValueFromTagDeletingScreen(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TagDeletingScreen(),
        ));
    setState(() {
      _tagDatabase.loadTagData();
    });
  }

  AlertDialog createNewTag(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 100,
        child: Column(
          children: <Widget>[
            TextField(
              controller: tagNameController,
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                hintText: 'New Tag Name',
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
                      setState(() {
                        _tagDatabase.existingTags.add(tagNameController.text);
                        _tagDatabase.updateTagDataBase();
                      });
                      tagNameController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Set<ElevatedButton> generateNoteTags() {
    Set<ElevatedButton> tagButtons = {};

    for (var i in _tagDatabase.existingTags) {
      ElevatedButton button = ElevatedButton(
        onPressed: () {
          setState(() {
            selectedTagName = i;
            _sendTagNameBack(context);
          });
        },
        child: Text(i),
        style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
      );
      tagButtons.add(button);
    }
    return tagButtons;
  }
}
