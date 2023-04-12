import 'package:flutter/material.dart';
import 'tag_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../databases/note_database.dart';
import '../databases/tag_database.dart';

class NoteMakingScreen extends StatefulWidget {
  const NoteMakingScreen({super.key});

  @override
  _NoteMakingScreenState createState() => _NoteMakingScreenState();
}

class _NoteMakingScreenState extends State<NoteMakingScreen> {
  final _tagBox = Hive.box('boxForTags');
  final TagDatabase _tagDatabase = TagDatabase();

  final _noteBox = Hive.box('boxForNotes');
  final NoteDatabase _noteDatabase = NoteDatabase();

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController noteContentController = TextEditingController();
  String tagName = 'No Tag';

  Note newNote = Note(noteTitle: '', noteContent: '', tagName: 'No Tag');
  @override
  void initState() {
    super.initState();
    if (_noteBox.get('NOTES') == null) {
      _noteDatabase.createInitialNoteData();
    } else {
      _noteDatabase.loadNoteData();
    }
    _noteDatabase.updateNoteDataBase();

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text('New Note', style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * (3 / 100),
              MediaQuery.of(context).size.height * (2 / 100),
              MediaQuery.of(context).size.width * (3 / 100),
              MediaQuery.of(context).size.height * (2 / 100)),
          child: Column(
            children: <Widget>[
              TextField(
                controller: noteTitleController,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Note\'s Title',
                  enabledBorder: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () {
                    _awaitReturnValueFromTagMakingScreen(context);
                  },
                  child: Text(tagName),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                  ),
                ),
              ),
              TextField(
                controller: noteContentController,
                minLines: (MediaQuery.of(context).size.height.round() / 100 * 3)
                    .toInt(),
                maxLines: (MediaQuery.of(context).size.height.round() / 100 * 3)
                    .toInt(),
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Input notes here',
                  enabledBorder: InputBorder.none,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(
                      (MediaQuery.of(context).size.height / 100)
                          .roundToDouble())),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      setState(() {
                        newNote.noteContent = noteContentController.text;
                        newNote.noteTitle = noteTitleController.text;
                        newNote.tagName = tagName;
                      });
                      _verifyAndSendNoteBack(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _verifyAndSendNoteBack(BuildContext context) {
    if (newNote.noteTitle.isEmpty || newNote.noteContent.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Error!'),
              content: Text('Make sure to fill up everything!'),
            );
          });
    } else {
      _noteDatabase.setNewNote(
          newNote.noteTitle, newNote.noteContent, newNote.tagName);
      _noteDatabase.updateNoteDataBase();

      Navigator.pop(context);
    }
  }

  void _awaitReturnValueFromTagMakingScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TagMakingScreen(),
        ));
    setState(() {
      tagName = result ?? 'No Tag';
    });
  }
}

class Note {
  String noteTitle, noteContent, tagName;

  Note(
      {required this.noteTitle,
      required this.noteContent,
      required this.tagName});
}
