import 'dart:convert';

class Note {
  String title;
  String description;
  String id;
  DateTime date;
  Note(
      {required this.title,
      required this.description,
      required this.date,
      required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: DateTime.parse(json['date']));
  }
}
