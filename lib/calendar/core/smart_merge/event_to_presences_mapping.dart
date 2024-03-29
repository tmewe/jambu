import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/ms_graph/model/model.dart';

class EventToPresencesMapping {
  EventToPresencesMapping({
    required this.event,
  });

  final MSEvent event;

  List<Presence> call() {
    // Get the duration of the event (could be multiple days)
    final eventDuration = event.end.date.difference(event.start.date).abs();

    var eventLength = eventDuration.inHours / 24;
    eventLength = eventLength < 1 ? 1 : eventLength;

    final presences = <Presence>[];
    for (var i = 0; i < eventLength; i++) {
      final date = event.start.date.add(Duration(days: i));
      if (event.isAllDayOOF) {
        presences.add(
          Presence(date: date, isPresent: false, reason: event.subject),
        );
      } else if (event.isOfficeEvent) {
        presences.add(
          Presence(date: date, isPresent: true, reason: event.subject),
        );
      }
    }
    return presences;
  }
}
