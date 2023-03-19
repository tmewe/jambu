// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MSEventAttendee {
  MSEventAttendee({
    required this.type,
  });

  factory MSEventAttendee.fromMap(Map<String, dynamic> map) {
    return MSEventAttendee(
      type: map['type'] as String,
    );
  }

  factory MSEventAttendee.fromJson(String source) =>
      MSEventAttendee.fromMap(json.decode(source) as Map<String, dynamic>);

  final String type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
    };
  }

  @override
  String toString() => type;
}
