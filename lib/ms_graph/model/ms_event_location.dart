import 'dart:convert';

import 'package:jambu/constants.dart';

class MSEventLocation {
  MSEventLocation({
    required this.displayName,
    this.locationType,
  });

  factory MSEventLocation.fromMap(Map<String, dynamic> map) {
    return MSEventLocation(
      displayName: map['displayName'] as String,
      locationType:
          map['locationType'] != null ? map['locationType'] as String : null,
    );
  }

  factory MSEventLocation.fromJson(String source) => MSEventLocation.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String displayName;
  final String? locationType;

  bool get isInMeetingRoom {
    if (displayName.isEmpty) return false;

    for (final room in Constants.allMeetingRooms) {
      if (displayName.toLowerCase().contains(room.toLowerCase())) return true;
    }
    return false;
  }

  MSEventLocation copyWith({
    String? displayName,
    String? locationType,
  }) {
    return MSEventLocation(
      displayName: displayName ?? this.displayName,
      locationType: locationType ?? this.locationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'locationType': locationType,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => displayName;
}
