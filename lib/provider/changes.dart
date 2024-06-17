import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/schema/model.dart';
import 'package:uuid/uuid.dart';

class Providerclass extends ChangeNotifier {
  DateTime? _date;
  final List<Note> _notes = [];
  List<Note> get note => _notes;
  DateTime? get date => _date;
  var uuid = const Uuid();

  Providerclass() {
    _loadNotesFromPrefs();
  }

  void addNote(String title, String description) {
    String id = uuid.v4(); // Generate UUID string
    _notes.add(
        Note(title: title, description: description, date: _date!, id: id));
    debugPrint(_notes[0].toString());
    _saveNotetoPrefs();
    notifyListeners();
  }

  void removeNoteById(String id) {
    _notes.removeWhere((note) => note.id == id);
    _saveNotetoPrefs();
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
      _saveNotetoPrefs();
      notifyListeners();
    }
  }

  Future<void> _saveNotetoPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notesJson =
        _notes.map((note) => jsonEncode(note.toJson())).toList();
    prefs.setStringList('notes', notesJson);
  }

  Future<void> _loadNotesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notesJson = prefs.getStringList('notes');
    if (notesJson != null) {
      _notes.clear();
      _notes.addAll(notesJson.map((note) => Note.fromJson(jsonDecode(note))));
      notifyListeners();
    }
  }
}
