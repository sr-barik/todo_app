import 'package:flutter/material.dart';
import 'package:todo_app/schema/model.dart';
import 'package:uuid/uuid.dart';

class Providerclass extends ChangeNotifier {
  DateTime? _date;
  final List<Note> _notes = [];
  List<Note> get note => _notes;
  DateTime? get date => _date;
  var uuid = const Uuid();

  void addNote(String title, String description) {
    String id = uuid.v4(); // Generate UUID string
    _notes.add(
        Note(title: title, description: description, date: _date!, id: id));
    debugPrint(_notes[0].toString());
    notifyListeners();
  }

  void removeNoteById(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  void editNote(String id, String title, String description, DateTime date) {
    int index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = Note(
        id: id,
        title: title,
        description: description,
        date: date,
      );
      notifyListeners();
    }
  }
}
