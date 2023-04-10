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
    final calendars = await _msGraphRepository.fetchCalendars();

    for (final tag in _tagNames) {
      //  Check if calendar for tag already exists -> otherwise create one
      final calendarId = calendars
              .firstWhereOrNull((calendar) => calendar.name == tag.calendarName)
              ?.id ??
          await _msGraphRepository.createCalendar(name: tag.calendarName);

      if (calendarId == null) return;

      // Fetch all events from calendar
      final existingEvents =
          await _msGraphRepository.fetchEventsFromCalendar(calendarId);

      final updates = TagUpdates(
        tagName: tag,
        attendances: _attendances,
        eventsForTag: existingEvents,
      )();

      //  Convert events to batch requests
      var requestIndex = 0;
      final addRequests = updates.eventsToAdd.map(
        (event) => MSBatchRequest.createEvent(
          id: requestIndex++,
          event: event,
          calendarId: calendarId,
        ),
      );

      final deleteRequests =
          updates.eventsToRemove.map((e) => e.id).whereNotNull().map(
                (id) => MSBatchRequest.deleteEvent(
                  id: requestIndex++,
                  eventId: id,
                  calendarId: calendarId,
                ),
              );

      //  Upload batch requests
      final requests = [...deleteRequests, ...addRequests];
      await _msGraphRepository.uploadBatchRequest(requests);
    }
  }
}
