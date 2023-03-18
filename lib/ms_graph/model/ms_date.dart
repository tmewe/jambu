// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MSDate {
  const MSDate({
    required this.date,
    required this.timeZone,
  });

  final DateTime date;
  final String timeZone;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateTime': date.toIso8601String(),
      'timeZone': timeZone,
    };
  }

  factory MSDate.fromMap(Map<String, dynamic> map) {
    return MSDate(
      date: DateTime.parse(map['dateTime'] as String),
      timeZone: map['timeZone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MSDate.fromJson(String source) =>
      MSDate.fromMap(json.decode(source) as Map<String, dynamic>);
}
