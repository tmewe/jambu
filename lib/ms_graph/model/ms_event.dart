import 'dart:convert';

import 'package:jambu/ms_graph/model/ms_date.dart';
import 'package:jambu/ms_graph/model/ms_event_location.dart';
import 'package:jambu/ms_graph/model/ms_event_response_status.dart';

class MSEvent {
  MSEvent({
    required this.subject,
    required this.isAllDay,
    required this.isOnlineMeeting,
    required this.start,
    required this.end,
    required this.showAs,
    this.id,
    this.location,
    this.isReminderOn,
    this.responseStatus,
  });

  factory MSEvent.fromMap(Map<String, dynamic> map) {
    return MSEvent(
      subject: map['subject'] as String,
      isAllDay: map['isAllDay'] as bool,
      isOnlineMeeting: map['isOnlineMeeting'] as bool,
      start: MSDate.fromMap(map['start'] as Map<String, dynamic>),
      end: MSDate.fromMap(map['end'] as Map<String, dynamic>),
      showAs: EventStatus.fromJson(map['showAs'] as String),
      id: map['id'] != null ? map['id'] as String : null,
      location: map['location'] != null
          ? MSEventLocation.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      isReminderOn:
          map['isReminderOn'] != null ? map['isReminderOn'] as bool : null,
      responseStatus: map['responseStatus'] != null
          ? MSEventResponseStatus.fromMap(
              map['responseStatus'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  factory MSEvent.fromJson(String source) => MSEvent.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String subject;
  final bool isAllDay;
  final bool isOnlineMeeting;
  final MSDate start;
  final MSDate end;
  final EventStatus showAs;
  final String? id;
  final MSEventLocation? location;
  final bool? isReminderOn;
  final MSEventResponseStatus? responseStatus;

  MSEvent copyWith({
    String? subject,
    bool? isAllDay,
    bool? isOnlineMeeting,
    MSDate? start,
    MSDate? end,
    EventStatus? showAs,
    String? id,
    MSEventLocation? location,
    bool? isReminderOn,
    MSEventResponseStatus? responseStatus,
  }) {
    return MSEvent(
      subject: subject ?? this.subject,
      isAllDay: isAllDay ?? this.isAllDay,
      isOnlineMeeting: isOnlineMeeting ?? this.isOnlineMeeting,
      start: start ?? this.start,
      end: end ?? this.end,
      showAs: showAs ?? this.showAs,
      id: id ?? this.id,
      location: location ?? this.location,
      isReminderOn: isReminderOn ?? this.isReminderOn,
      responseStatus: responseStatus ?? this.responseStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subject': subject,
      'isAllDay': isAllDay,
      'isOnlineMeeting': isOnlineMeeting,
      'start': start.toMap(),
      'end': end.toMap(),
      'showAs': showAs.toJson(),
      'id': id,
      'location': location?.toMap(),
      'isReminderOn': isReminderOn,
      'responseStatus': responseStatus?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'MSEvent(subject: $subject, isAllDay: $isAllDay, '
        'isOnlineMeeting: $isOnlineMeeting, start: $start, end: $end, '
        'showAs: $showAs, id: $id, location: $location, '
        'isReminderOn: $isReminderOn, responseStatus: $responseStatus)';
  }
}

enum EventStatus {
  free,
  tentative,
  busy,
  oof,
  workingElsewhere,
  unknown;

  String toJson() => name;
  static EventStatus fromJson(String json) => values.byName(json);
}
