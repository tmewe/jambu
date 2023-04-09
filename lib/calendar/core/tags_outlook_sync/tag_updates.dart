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

class TagUpdates {
  TagUpdates({
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
    //  Nutzer mit Tag in Events mappen
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

    //  Events, die zu adden sind bestimmen (neu - existiert)
    final eventsToAdd =
        updatedEvents.toSet().difference(_events.toSet()).toList();

    //  Events, die zu löschen sind bestimmen (existiert - neu)
    final eventsToRemove =
        _events.toSet().difference(updatedEvents.toSet()).toList();

    return TagEventsUpdates(
      eventsToAdd: eventsToAdd,
      eventsToRemove: eventsToRemove,
    );
  }
}
