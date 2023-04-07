// ignore_for_file: sort_constructors_first
import 'dart:convert';

import 'package:jambu/model/model.dart';

class HolidayRaw {
  const HolidayRaw({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.name,
    required this.nationwide,
  });

  final String id;
  final String startDate;
  final String endDate;
  final String type;
  final List<Name> name;
  final bool nationwide;

  factory HolidayRaw.fromMap(Map<String, dynamic> map) {
    return HolidayRaw(
      id: map['id'] as String,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      type: map['type'] as String,
      name: List<Name>.from(
        (map['name'] as List<int>).map<Name>(
          (x) => Name.fromMap(x as Map<String, dynamic>),
        ),
      ),
      nationwide: map['nationwide'] as bool,
    );
  }

  factory HolidayRaw.fromJson(dynamic source) =>
      HolidayRaw.fromMap(source as Map<String, dynamic>);

  Holiday toModel() {
    return Holiday(
      name: name.first.text,
      date: startDate,
      nationwide: nationwide,
    );
  }
}

class Name {
  const Name({
    required this.language,
    required this.text,
  });

  final String language;
  final String text;

  factory Name.fromMap(Map<String, dynamic> map) {
    return Name(
      language: map['language'] as String,
      text: map['text'] as String,
    );
  }

  factory Name.fromJson(String source) =>
      Name.fromMap(json.decode(source) as Map<String, dynamic>);
}
