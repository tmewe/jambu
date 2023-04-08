import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/extension/extension.dart';
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

  Future<Uint8List?> profilePhoto() {
    return _msGraphDataSource.profilePhoto();
  }

  Future<List<MSCalendar>> fetchCalendars() {
    return _msGraphDataSource.fetchCalendars();
  }

  Future<void> createCalendar({required String name, Color? color}) async {
    final hexColor = color != null ? '#${color.value.toRadixString(16)}' : null;
    final msCalendar = MSCalendar(name: name, hexColor: hexColor);
    await _msGraphDataSource.createCalendar(msCalendar);
  }

  Future<List<MSEvent>> eventsFromToday() {
    return _msGraphDataSource.eventsFrom(fromDate: DateTime.now().midnight);
  }

  Future<List<MSEvent>> fetchEventsFromCalendar(String calendarId) async {
    return [];
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
    final eventsAtDate = await _msGraphDataSource.eventsAt(date: date);
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
