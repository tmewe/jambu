import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

class OutlookEventsUpdates {
  OutlookEventsUpdates({
    required this.eventsToAdd,
    required this.eventsToRemove,
  });

  final List<MSEvent> eventsToAdd;
  final List<MSEvent> eventsToRemove;
}

class OutlookUpdates {
  OutlookUpdates({
    required this.officeEvents,
    required this.userAttendances,
  });

  final List<MSEvent> officeEvents;
  final List<Attendance> userAttendances;

  OutlookEventsUpdates call() {
    final updatedEvents =
        userAttendances.map((e) => MSEvent.office(date: e.date));

    final uniqueOfficeEvents = officeEvents.toSet();
    final uniqueUpdatedEvents = updatedEvents.toSet();

    final duplicateEvents = [...officeEvents];
    for (final unique in uniqueOfficeEvents) {
      if (duplicateEvents.contains(unique)) duplicateEvents.remove(unique);
    }

    final eventsToAdd = uniqueUpdatedEvents.difference(uniqueOfficeEvents);
    final eventsToRemove = uniqueOfficeEvents.difference(uniqueUpdatedEvents);

    return OutlookEventsUpdates(
      eventsToAdd: eventsToAdd.toList(),
      eventsToRemove: [...duplicateEvents, ...eventsToRemove],
    );
  }
}
