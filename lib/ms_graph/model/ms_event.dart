// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:jambu/constants.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/ms_graph/model/ms_date.dart';
import 'package:jambu/ms_graph/model/ms_event_attendee.dart';
import 'package:jambu/ms_graph/model/ms_event_location.dart';
import 'package:jambu/ms_graph/model/ms_event_response_status.dart';

@immutable
class MSEvent extends Equatable {
  const MSEvent({
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
    this.attendees = const [],
  });

  factory MSEvent.office({required DateTime date}) => MSEvent(
        subject: Constants.officeEventSubject,
        isAllDay: true,
        isOnlineMeeting: false,
        start: MSDate.german(date: date.midnight),
        end: MSDate.german(date: date.add(const Duration(days: 1)).midnight),
        showAs: EventStatus.free,
        isReminderOn: false,
      );

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
      attendees: map['attendees'] != null
          ? List<MSEventAttendee>.from(
              (map['attendees'] as List<dynamic>).map<MSEventAttendee>(
                (x) => MSEventAttendee.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
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
  final List<MSEventAttendee> attendees;

  bool get isWholeDayOOF => isAllDay && showAs == EventStatus.oof;

  // TODO(tim): Filter out jupdate events
  bool get isPresenceWithMultipleAttendees {
    return !isOnlineMeeting &&
        responseStatus?.response == ResponseStatus.accepted &&
        attendees.where((a) => a.type == 'required').length > 1;
  }

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
      'attendees': attendees.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'MSEvent(subject: $subject, isAllDay: $isAllDay, '
        'isOnlineMeeting: $isOnlineMeeting, start: $start, end: $end, '
        'showAs: $showAs, location: $location, '
        'isReminderOn: $isReminderOn, responseStatus: $responseStatus) '
        'attendees: $attendees';
  }

  @override
  List<Object> get props {
    return [
      subject,
      isAllDay,
      isOnlineMeeting,
      start,
      end,
      showAs,
      attendees,
    ];
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
