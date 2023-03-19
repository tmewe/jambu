// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MSEventResponseStatus {
  const MSEventResponseStatus({
    this.response,
    this.time,
  });

  factory MSEventResponseStatus.fromMap(Map<String, dynamic> map) {
    return MSEventResponseStatus(
      response: map['response'] != null
          ? ResponseStatus.fromJson(map['response'] as String)
          : null,
      time: map['time'] != null ? DateTime.parse(map['time'] as String) : null,
    );
  }

  factory MSEventResponseStatus.fromJson(String source) =>
      MSEventResponseStatus.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final ResponseStatus? response;
  final DateTime? time;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'response': response?.toJson(),
      'time': time?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => '$response';
}

enum ResponseStatus {
  accepted,
  organizer,
  none,
  tentativelyAccepted,
  declined,
  notResponded;

  String toJson() => name;
  static ResponseStatus fromJson(String json) => values.byName(json);
}
