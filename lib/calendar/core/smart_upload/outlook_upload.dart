import 'package:flutter/foundation.dart';
import 'package:jambu/calendar/core/smart_upload/outlook_updates.dart';
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
  })  : _currentUser = currentUser,
        _msEvents = msEvents,
        _attendances = attendances,
        _msGraphRepository = msGraphRepository;

  final User _currentUser;
  final List<MSEvent> _msEvents;
  final List<Attendance> _attendances;
  final MSGraphRepository _msGraphRepository;

  Future<void> call() async {
    final userAttendances = _attendances.wherePresentUserId(_currentUser.id);

    final officeEvents = _msEvents
        .where((event) => event.subject == Constants.officeEventSubject)
        .toList();

    final updates = OutlookUpdates(
      officeEvents: officeEvents,
      userAttendances: userAttendances,
    )();

    final requests = mapEventsToRequests(
      eventsToRemove: updates.eventsToRemove,
      eventsToAdd: updates.eventsToAdd,
    );

    debugPrint(
      'Deleting ${updates.eventsToRemove.length} events '
      'and adding ${updates.eventsToAdd.length} events',
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
}
