import 'package:collection/collection.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/model/ms_calendar.dart';
import 'package:jambu/ms_graph/model/ms_event.dart';
import 'package:jambu/repository/repository.dart';

class TagsOutlookSync {
  const TagsOutlookSync({
    required MSGraphRepository msGraphRepository,
    required List<CalendarWeek> attendances,
    required List<Tag> tags,
  })  : _msGraphRepository = msGraphRepository,
        _attendances = attendances,
        _tags = tags;

  final MSGraphRepository _msGraphRepository;
  final List<CalendarWeek> _attendances;
  final List<Tag> _tags;

  Future<void> call() async {
    // Alle Kalendar fetchen
    final calendars = await _msGraphRepository.fetchCalendars();

    // Über alle Tags iterieren
    for (final tag in _tags) {
      //  Checken ob Kalendar für Tag existiert -> sonst Kalendar anlegen
      final calendarId = calendars
              .firstWhereOrNull((calendar) => calendar.name == tag.name)
              ?.id ??
          await _msGraphRepository.createCalendar(name: tag.name);

      if (calendarId == null) return;

      //  Alle Events fetchen
      final existingEvents =
          await _msGraphRepository.fetchEventsFromCalendar(calendarId);

      //  Nutzer mit Tag in Events mappen
      final updatedEvents = _attendances
          .map((a) => a.days)
          .expand((e) => e)
          .map((day) {
            return day.users.where((user) => user.tags.contains(tag.name)).map(
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
          updatedEvents.toSet().difference(existingEvents.toSet()).toList();

      //  Events, die zu löschen sind bestimmen (existiert - neu)
      final eventsToRemove =
          existingEvents.toSet().difference(updatedEvents.toSet()).toList();

      //  Events in Batch Request konvertieren
      //  Batch Request hochladen
    }
  }
}
