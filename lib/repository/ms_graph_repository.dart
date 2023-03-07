import 'package:flutter/material.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

class MSGraphRepository {
  MSGraphRepository({
    required MSGraphDataSource msGraphDataSource,
  }) : _msGraphDataSource = msGraphDataSource;

  final MSGraphDataSource _msGraphDataSource;
  final _germanTimeZone = 'W. Europe Standard Time';

  Future<void> me() async {
    final response = await _msGraphDataSource.me();
    debugPrint('$response');
  }

  Future<void> calendars() async {
    final calendars = await _msGraphDataSource.calendars();
    debugPrint('$calendars');
  }

  Future<void> events() async {
    final events = await _msGraphDataSource.events();
    debugPrint('$events');
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
    await _msGraphDataSource.create(event: msEvent);
  }
}
