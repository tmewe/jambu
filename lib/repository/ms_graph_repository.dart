import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  Future<void> calendars() async {
    final calendars = await _msGraphDataSource.calendars();
    debugPrint('$calendars');
  }

  Future<void> createCalendar({required String name, Color? color}) async {
    final hexColor = color != null ? '#${color.value.toRadixString(16)}' : null;
    final msCalendar = MSCalendar(name: name, hexColor: hexColor);
    await _msGraphDataSource.createCalendar(msCalendar);
  }

  Future<List<MSEvent>> eventsFromToday() {
    return _msGraphDataSource.events(fromDate: DateTime.now());
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
}
