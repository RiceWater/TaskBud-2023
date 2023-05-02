import 'package:flutter/material.dart';
import 'tag_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../databases/note_database.dart';
import '../databases/tag_database.dart';

class NoteEditingScreen extends StatefulWidget {
  int idToEdit; //asd
  NoteEditingScreen({required this.idToEdit, super.key});

  @override
  _NoteEditingScreenState createState() => _NoteEditingScreenState();
}

class _NoteEditingScreenState extends State<NoteEditingScreen> {
  final _tagBox = Hive.box('boxForTags');
  final TagDatabase _tagDatabase = TagDatabase();

  final _noteBox = Hive.box('boxForNotes');
  final NoteDatabase _noteDatabase = NoteDatabase();

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController noteContentController = TextEditingController();
  String tagName = 'No Tag';
  int noteIndex = 0;

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
    loadNoteEdits();

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    saveNoteEdits();
                  });
                  _verifyAndSendEditedNoteBack(context);
                },
              ),
              title: Row(
                children: [
                  const Text('Edit Note',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        deleteNote();
                      },
                      icon: const Icon(Icons.delete)),
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
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton(
                      onPressed: () {
                        _awaitReturnNewValueFromTagMakingScreen(context);
                      },
                      child: Text(tagName),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                      ),
                    ),
                  ),
                  TextField(
                    controller: noteContentController,
                    minLines:
                        (MediaQuery.of(context).size.height.round() / 100 * 3)
                            .toInt(),
                    maxLines:
                        (MediaQuery.of(context).size.height.round() / 100 * 3)
                            .toInt(),
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Input notes here',
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ))));
  }

  void deleteNote() {
    String deleteValue =
        'delete-31415926535delete-31415926535delete-31415926535';
    _noteDatabase.existingNotes[noteIndex].noteTitle = deleteValue;
    _noteDatabase.existingNotes[noteIndex].noteContent = deleteValue;
    tagName = deleteValue;
    saveNoteEdits();
    Navigator.pop(context);
  }

  void _verifyAndSendEditedNoteBack(BuildContext context) {
    if (_noteDatabase.existingNotes[noteIndex].noteTitle.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Error!'),
              content: Text('Make sure to have a title!'),
            );
          });
    } else {
      saveNoteEdits();
      Navigator.pop(context);
    }
  }

  void _awaitReturnNewValueFromTagMakingScreen(BuildContext context) async {
    saveNoteEdits();

    final String result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TagMakingScreen(),
        ));
    setState(() {
      tagName = result ?? 'No Tag';
      _noteDatabase.existingNotes[noteIndex].tagName = tagName;
    });
  }

  void saveNoteEdits() {
    _noteDatabase.existingNotes[noteIndex].noteTitle = noteTitleController.text;
    _noteDatabase.existingNotes[noteIndex].noteContent =
        noteContentController.text;
    _noteDatabase.existingNotes[noteIndex].tagName = tagName;
    _noteDatabase.updateNoteDataBase();
  }

  void loadNoteEdits() {
    for (int i = 0; i < _noteDatabase.existingNotes.length; i++) {
      if (widget.idToEdit == _noteDatabase.existingNotes[i].id) {
        noteIndex = i;
        noteTitleController.text = _noteDatabase.existingNotes[i].noteTitle;
        noteContentController.text = _noteDatabase.existingNotes[i].noteContent;
        tagName = _noteDatabase.existingNotes[i].tagName;
        break;
      }
    }
  }
}
