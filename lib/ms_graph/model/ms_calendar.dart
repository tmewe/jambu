import 'dart:convert';

class MSCalendar {
  MSCalendar({
    required this.name,
    this.id,
    this.hexColor,
  });

  factory MSCalendar.fromMap(Map<String, dynamic> map) {
    return MSCalendar(
      name: map['name'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      hexColor: map['hexColor'] != null ? map['hexColor'] as String : null,
    );
  }

  factory MSCalendar.fromJson(String source) => MSCalendar.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String name;
  final String? id;
  final String? hexColor;

  MSCalendar copyWith({
    String? name,
    String? id,
    String? hexColor,
  }) {
    return MSCalendar(
      name: name ?? this.name,
      id: id ?? this.id,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'hexColor': hexColor,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'MSCalendar(name: $name, id: $id, hexColor: $hexColor)';
}
