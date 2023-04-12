import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';

class NoteDatabase {
  final _noteBox = Hive.box('boxForNotes');
  List<Note> existingNotes = [];

  void createInitialNoteData() {
    existingNotes = [
      Note(
          noteTitle: 'My First Note',
          noteContent: 'This is where I can put anything!',
          tagName: 'No Tag'),
      Note(
          noteTitle: 'Things to Remember',
          noteContent: 'Work Hard, Play Hard!',
          tagName: 'Personal'),
      Note(
          noteTitle: 'Earn Money on the Side',
          noteContent: 'Rent a bike nearby and start delivering pizzas',
          tagName: 'Business')
    ];
  }

  void loadNoteData() {
    existingNotes = _noteBox.get('NOTES');
  }

  void updateNoteDataBase() {
    _noteBox.put('NOTES', existingNotes);
  }

  void removeNote(int id) {
    _noteBox.deleteAt(id);
  }

  void setNewNote(String noteTitle, String noteContent, String tagName) {
    Note newNote =
        Note(noteTitle: noteTitle, noteContent: noteContent, tagName: tagName);
    existingNotes.add(newNote);
  }

  List<String> provideNoteDetails(i) {
    List<String> noteDetails = [
      existingNotes[i].noteTitle,
      existingNotes[i].noteContent,
      existingNotes[i].tagName,
      existingNotes[i].id.toString(),
    ];
    return noteDetails;
  }
}
