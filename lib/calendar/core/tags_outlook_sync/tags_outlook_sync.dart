import 'package:collection/collection.dart';
import 'package:jambu/calendar/core/tags_outlook_sync/tag_updates.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/ms_graph/ms_graph.dart';
import 'package:jambu/repository/repository.dart';

class TagsOutlookSync {
  const TagsOutlookSync({
    required MSGraphRepository msGraphRepository,
    required List<CalendarWeek> attendances,
    required Iterable<String> tagNames,
  })  : _msGraphRepository = msGraphRepository,
        _attendances = attendances,
        _tagNames = tagNames;

  final MSGraphRepository _msGraphRepository;
  final List<CalendarWeek> _attendances;
  final Iterable<String> _tagNames;

  Future<void> call() async {
    // Alle Kalendar fetchen
    final calendars = await _msGraphRepository.fetchCalendars();

    // Über alle Tags iterieren
    for (final tag in _tagNames) {
      //  Checken ob Kalendar für Tag existiert -> sonst Kalendar anlegen
      final calendarId = calendars
              .firstWhereOrNull((calendar) => calendar.name == tag.calendarName)
              ?.id ??
          await _msGraphRepository.createCalendar(name: tag.calendarName);

      if (calendarId == null) return;

      //  Alle Events fetchen
      final existingEvents =
          await _msGraphRepository.fetchEventsFromCalendar(calendarId);

      final updates = TagUpdates(
        tagName: tag,
        attendances: _attendances,
        eventsForTag: existingEvents,
      )();

      //  Events in Batch Request konvertieren
      var requestIndex = 0;
      final addRequests = updates.eventsToAdd.map(
        (event) => MSBatchRequest.createEvent(
          id: requestIndex++,
          event: event,
          calendarId: calendarId,
        ),
      );

      final deleteRequests = updates.eventsToRemove.map(
        (event) => MSBatchRequest.deleteEvent(
          id: requestIndex++,
          eventId: event.id ?? '0',
          calendarId: calendarId,
        ),
      );

      //  Batch Request hochladen
      final requests = [...deleteRequests, ...addRequests];
      await _msGraphRepository.uploadBatchRequest(requests);
    }
  }
}
