import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

class TagEventsUpdates {
  TagEventsUpdates({
    required this.eventsToAdd,
    required this.eventsToRemove,
  });

  final List<MSEvent> eventsToAdd;
  final List<MSEvent> eventsToRemove;
}

class TagOutlookUpdates {
  TagOutlookUpdates({
    required String tagName,
    required List<CalendarWeek> attendances,
    required List<MSEvent> eventsForTag,
  })  : _tagName = tagName,
        _attendances = attendances,
        _events = eventsForTag;

  final String _tagName;
  final List<CalendarWeek> _attendances;
  final List<MSEvent> _events;

  TagEventsUpdates call() {
    //  Map users with given tag to events
    final updatedEvents = _attendances
        .map((a) => a.days)
        .expand((e) => e)
        .map((day) {
          return day.users.where((user) => user.tags.contains(_tagName)).map(
                (user) => MSEvent.fromUser(
                  date: day.date,
                  userName: user.name,
                ),
              );
        })
        .expand((e) => e)
        .toList();

    final uniqueTagEvents = _events.toSet();
    final uniqueUpdatedEvents = updatedEvents.toSet();

    final duplicateEvents = [..._events];
    for (final unique in uniqueTagEvents) {
      if (duplicateEvents.contains(unique)) duplicateEvents.remove(unique);
    }

    final eventsToAdd =
        uniqueUpdatedEvents.difference(uniqueTagEvents).toList();

    final eventsToRemove =
        uniqueTagEvents.difference(uniqueUpdatedEvents).toList();

    return TagEventsUpdates(
      eventsToAdd: eventsToAdd,
      eventsToRemove: [...duplicateEvents, ...eventsToRemove],
    );
  }
}
