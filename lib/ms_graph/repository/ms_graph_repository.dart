import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

class MSGraphRepository {
  MSGraphRepository({
    required MSGraphDataSource msGraphDataSource,
  }) : _msGraphDataSource = msGraphDataSource;

  final MSGraphDataSource _msGraphDataSource;
  final _germanTimeZone = 'W. Europe Standard Time';

  Future<MSUser?> me() {
    return _msGraphDataSource.me();
  }

  Future<Uint8List?> fetchProfilePhoto() {
    return _msGraphDataSource.fetchProfilePhoto();
  }

  Future<List<MSCalendar>> fetchCalendars() {
    return _msGraphDataSource.fetchCalendars();
  }

  Future<String?> createCalendar({required String name, Color? color}) async {
    final hexColor = color != null ? '#${color.value.toRadixString(16)}' : null;
    final msCalendar = MSCalendar(name: name, hexColor: hexColor);
    return _msGraphDataSource.createCalendar(msCalendar);
  }

  Future<void> deleteCalendar({required String name}) async {
    final calendars = await _msGraphDataSource.fetchCalendars();
    final calendarId =
        calendars.firstWhereOrNull((calendar) => calendar.name == name)?.id;
    if (calendarId != null) {
      await _msGraphDataSource.deleteCalendar(calendarId);
    }
  }

  Future<void> updateCalendarName({
    required String calendarName,
    required String newCalendarName,
  }) async {
    final calendars = await _msGraphDataSource.fetchCalendars();
    final calendarId = calendars
        .firstWhereOrNull((calendar) => calendar.name == calendarName)
        ?.id;
    if (calendarId != null) {
      await _msGraphDataSource.updateCalendarName(
        calendarId: calendarId,
        newCalendarName: newCalendarName,
      );
    }
  }

  Future<List<MSEvent>> fetchEventsFromStartOfWeek({String? calendarId}) {
    return _msGraphDataSource.fetchEventsStarting(calendarId: calendarId);
  }

  Future<List<MSEvent>> fetchEventsFromCalendar(String calendarId) async {
    return _msGraphDataSource.fetchEventsStarting(calendarId: calendarId);
  }

  Future<void> createEventAt({required DateTime dateTime}) async {
    final startDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final tomorrow = dateTime.add(const Duration(days: 1));
    final endDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    final msStartDate = MSDate(date: startDate, timeZone: _germanTimeZone);
    final msEndDate = MSDate(date: endDate, timeZone: _germanTimeZone);

    final msEvent = MSEvent(
      subject: '💼 Im Büro',
      isAllDay: true,
      isOnlineMeeting: false,
      start: msStartDate,
      end: msEndDate,
      showAs: EventStatus.free,
      isReminderOn: false,
    );
    await _msGraphDataSource.createEvent(msEvent);
  }

  Future<void> uploadBatchRequest(List<MSBatchRequest> requests) async {
    return _msGraphDataSource.uploadBatchRequest(requests);
  }

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
  }) async {
    final eventsAtDate = await _msGraphDataSource.fetchAllDayEventsAt(
      date,
      calendarId: kDebugMode ? Constants.testCalendarId : null,
    );
    final officeEventAtDate = eventsAtDate.firstWhereOrNull(
      (event) => event.subject == Constants.officeEventSubject,
    );

    if (officeEventAtDate == null && isAttending) {
      await _msGraphDataSource.createEvent(MSEvent.office(date: date));
    } else if (officeEventAtDate != null &&
        officeEventAtDate.id != null &&
        !isAttending) {
      await _msGraphDataSource.deleteEvent(officeEventAtDate.id!);
    }
  }
}
