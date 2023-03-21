import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/ms_graph/model/model.dart';

class EventToPresencesMapping {
  EventToPresencesMapping({
    required this.event,
  });

  final MSEvent event;

  List<Presence> call() {
    // Get the duration of the event (could be multiple days)
    var eventDuration =
        event.end.date.difference(event.start.date).abs().inDays;

    // One day is the minimum
    if (eventDuration == 0) {
      eventDuration = 1;
    }
    // Duration = one day means that the event takes place at two dates
    else {
      eventDuration++;
    }
    final presences = <Presence>[];
    for (var i = 0; i < eventDuration; i++) {
      final date = event.start.date.add(Duration(days: i));
      if (event.isWholeDayOOF) {
        presences.add(Presence(date: date, isPresent: false));
      } else if (event.isPresenceWithMultipleAttendees) {
        presences.add(Presence(date: date, isPresent: true));
      }
    }
    return presences;
  }
}
