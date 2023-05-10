import 'dart:math';

import 'package:flutter/material.dart'; //a
import 'note_making_page.dart';
import 'note_editing_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../databases/note_database.dart';
import '../databases/tag_database.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _tagBox = Hive.box('boxForTags');
  final TagDatabase _tagDatabase = TagDatabase();

  final _noteBox = Hive.box('boxForNotes');
  final NoteDatabase _noteDatabase = NoteDatabase();

  List<ExpansionTagContent> expansionTags = [];

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //expansionTags.clear();
    initializeExpansionTags();
    return Scaffold(
      backgroundColor: Color(0xffe3cc9c),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              expansionTags[index].isExpanded = !isExpanded;
            });
          },
          children: expansionTags.map((ExpansionTagContent item) {
            return ExpansionPanel(
              backgroundColor: const Color(0xffFEFBEA),
              headerBuilder: (BuildContext context, bool isExpanded) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      item.isExpanded = !item.isExpanded;
                    });
                  },
                  child: ListTile(
                    title: Text(item.tagName +
                        ' (' +
                        item.totalTagCount.toString() +
                        ')'),
                  ),
                );
              },
              body: ListView.builder(
                shrinkWrap: true,
                itemCount: item.notesWithSameTag.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      _awaitReturnValueFromNoteEditingScreen(
                          context, item.notesWithSameTag[index]);
                    },
                    child: ListTile(
                      title: Text(item.notesWithSameTag[index].noteTitle),
                      //tileColor: _hoverColor,
                    ),
                  );
                },
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.add),
        onPressed: () {
          _awaitReturnNoteFromNoteMakingScreen(context);
        },
      ),
    );
  }

  void initializeExpansionTags() {
    int totalTagCount = 0;
    List<Note> notesWithSameTag = [];
    _tagDatabase.loadTagData();

    //Creates expanionTags based on _tagDatabase
    for (var i in _tagDatabase.existingTags) {
      bool isTagExisting = false;
      for (var j in expansionTags) {
        if (i == j.tagName) {
          isTagExisting = true;
        }
      }
      if (!isTagExisting) {
        expansionTags.add(ExpansionTagContent(
            tagName: i, totalTagCount: totalTagCount, isExpanded: false));
      }
    }

    //Deletes expansionTags that has no tag counterpart in _tagDatabase
    for (var i in expansionTags) {
      bool isTagExisting = false;
      for (var j in _tagDatabase.existingTags) {
        if (i.tagName == j) {
          isTagExisting = true;
        }
      }
      if (!isTagExisting) {
        expansionTags.remove(i);
      }
    }

    //Changes notes to 'No Tag' if current tag assigned has been deleted
    for (var i in _noteDatabase.existingNotes) {
      bool tagExist = false;
      for (var j in expansionTags) {
        if (i.tagName == j.tagName) {
          tagExist = true;
          break;
        }
      }
      if (!tagExist) {
        i.tagName = 'No Tag';
      }
    }
    _noteDatabase.updateNoteDataBase();

    for (var i in expansionTags) {
      totalTagCount = 0;
      notesWithSameTag = [];

      for (int j = 0; j < _noteDatabase.existingNotes.length; j++) {
        List<String> noteDetailsFromDatabase =
            _noteDatabase.provideNoteDetails(j);
        Note noteFromDatabase = Note(
            noteTitle: noteDetailsFromDatabase[0],
            noteContent: noteDetailsFromDatabase[1],
            tagName: noteDetailsFromDatabase[2],
            id: int.parse(noteDetailsFromDatabase[3]));

        if (i.tagName == noteFromDatabase.tagName) {
          Note tmp = Note(
              noteTitle: noteFromDatabase.noteTitle,
              noteContent: noteFromDatabase.noteContent,
              tagName: noteFromDatabase.tagName,
              id: noteFromDatabase.id);

          notesWithSameTag = [...notesWithSameTag, tmp];
          totalTagCount++;
        }
      }
      i.notesWithSameTag = notesWithSameTag;
      i.totalTagCount = totalTagCount;
    }
  }

  //CREATE NOTE
  void _awaitReturnNoteFromNoteMakingScreen(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NoteMakingScreen(),
        ));

    if (_noteDatabase.existingNotes[_noteDatabase.existingNotes.length - 1]
                .noteTitle ==
            '' &&
        _noteDatabase.existingNotes[_noteDatabase.existingNotes.length - 1]
                .noteContent ==
            '') {
      return;
    }

    setState(() {
      _noteDatabase.loadNoteData();
      initializeExpansionTags();
    });
  }

  //EDIT NOTE
  void _awaitReturnValueFromNoteEditingScreen(
      BuildContext context, Note noteDetails) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteEditingScreen(idToEdit: noteDetails.id),
        ));

    _noteDatabase.loadNoteData();
    String deleteValue =
        'delete-31415926535delete-31415926535delete-31415926535';

    if (noteDetails.tagName == deleteValue &&
        noteDetails.noteContent == deleteValue &&
        noteDetails.noteTitle == deleteValue) {
      // for (var i in _noteDatabase.existingNotes) {
      //   if (i.id == noteDetails.id) {
      //     _noteDatabase.existingNotes.remove(i);
      //     _noteDatabase.updateNoteDataBase();
      //   }
      // }
      _noteDatabase.removeNote(noteDetails.id);
    }
    setState(() {
      initializeExpansionTags();
    });
  }
}

class Note {
  String noteTitle, noteContent, tagName;
  int id;

  Note(
      {required this.noteTitle,
      required this.noteContent,
      required this.tagName,
      required this.id});
}

class ExpansionTagContent {
  String tagName;
  int totalTagCount;
  bool isExpanded;
  List<Note> notesWithSameTag;

  ExpansionTagContent(
      {required this.tagName,
      required this.totalTagCount,
      required this.isExpanded,
      this.notesWithSameTag = const []});
}
