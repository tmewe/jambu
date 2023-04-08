import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';
import 'package:jambu/repository/repository.dart';

class OutlookUpload {
  OutlookUpload({
    required User currentUser,
    required List<MSEvent> msEvents,
    required List<Attendance> attendances,
    required MSGraphRepository msGraphRepository,
    DateTime? today,
  })  : _currentUser = currentUser,
        _msEvents = msEvents,
        _attendances = attendances,
        _msGraphRepository = msGraphRepository,
        _today = today ?? DateTime.now().midnight;

  final User _currentUser;
  final List<MSEvent> _msEvents;
  final List<Attendance> _attendances;
  final MSGraphRepository _msGraphRepository;
  final DateTime _today;

  Future<void> call() async {
    final uploadDate = _today.subtract(const Duration(hours: 1));
    final userAttendances = _attendances.wherePresentUserId(_currentUser.id);

    final officeEvents = _msEvents
        .where((event) => event.subject == Constants.officeEventSubject)
        .toList();

    final eventsToRemove = getEventsToRemove(
      events: officeEvents,
      userAttendances: userAttendances,
    ).where((e) => e.start.date.isAfter(uploadDate)).toList();

    final eventsToAdd = getEventsToAdd(
      events: officeEvents,
      userAttendances: userAttendances,
    ).where((e) => e.start.date.isAfter(uploadDate)).toList();

    final requests = mapEventsToRequests(
      eventsToRemove: eventsToRemove,
      eventsToAdd: eventsToAdd,
    );

    debugPrint(
      'Deleting ${eventsToRemove.length} events '
      'and adding ${eventsToAdd.length} events',
    );

    return _msGraphRepository.uploadBatchRequest(requests);
  }

  List<MSBatchRequest> mapEventsToRequests({
    required List<MSEvent> eventsToRemove,
    required List<MSEvent> eventsToAdd,
  }) {
    var requestIndex = 0;

    final deleteRequests = eventsToRemove.map((event) {
      return MSBatchRequest.deleteEvent(
        id: requestIndex++,
        eventId: event.id ?? '0',
        // TODO(tim): Just for testing - REMOVE
        calendarId: kDebugMode ? Constants.testCalendarId : null,
      );
    });

    final addRequests = eventsToAdd.map((event) {
      return MSBatchRequest.createEvent(
        id: requestIndex++,
        event: event,
        // TODO(tim): Just for testing - REMOVE
        calendarId: kDebugMode ? Constants.testCalendarId : null,
      );
    });

    return [...deleteRequests, ...addRequests].take(20).toList();
  }

  List<MSEvent> getEventsToRemove({
    required List<MSEvent> events,
    required List<Attendance> userAttendances,
  }) {
    final eventsToRemove = <MSEvent>[];
    for (final event in events) {
      final attendance = userAttendances.firstWhereOrNull(
        (a) => a.date.isSameDay(event.start.date),
      );
      if (attendance == null) {
        eventsToRemove.add(event);
      }
    }
    return eventsToRemove;
  }

  List<MSEvent> getEventsToAdd({
    required List<MSEvent> events,
    required List<Attendance> userAttendances,
  }) {
    final eventsToAdd = <MSEvent>[];
    for (final attendance in userAttendances) {
      final msEvent = events.firstWhereOrNull(
        (e) => e.start.date.isSameDay(attendance.date),
      );

      if (msEvent == null) {
        eventsToAdd.add(MSEvent.office(date: attendance.date));
      }
    }
    return eventsToAdd;
  }
}
