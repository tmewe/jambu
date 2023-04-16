import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/ms_graph/api/api.dart';
import 'package:jambu/ms_graph/model/model.dart';
import 'package:quiver/iterables.dart';

class MSGraphDataSource {
  MSGraphDataSource({
    required MSGraphAPI msGraphAPI,
  }) : _msGraphAPI = msGraphAPI;

  final MSGraphAPI _msGraphAPI;

  Future<MSUser?> me() async {
    final response = await _msGraphAPI.me();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }

    return MSUser.fromJson(response.body.toString());
  }

  Future<Uint8List?> fetchProfilePhoto() async {
    final response = await _msGraphAPI.photo();

    if (!response.isSuccessful) {
      return null;
    }

    return response.bodyBytes;
  }

  Future<List<MSCalendar>> fetchCalendars() async {
    final response = await _msGraphAPI.calendars();

    if (!response.isSuccessful) {
      return [];
    }

    final jsonBody =
        jsonDecode(response.body.toString()) as Map<String, dynamic>;
    final calendarsJson = jsonBody['value'] as List<dynamic>;
    final calendarsJsonList =
        calendarsJson.map((e) => e as Map<String, dynamic>);
    final calendars = calendarsJsonList.map(MSCalendar.fromMap).toList();
    return calendars;
  }

  /// Create a new calendar and returns the id
  Future<String?> createCalendar(MSCalendar calendar) async {
    final jsonCalendar = calendar.toJson();
    final response = await _msGraphAPI.createCalendar(jsonCalendar);

    if (!response.isSuccessful) {
      return null;
    }
    final jsonBody =
        jsonDecode(response.body.toString()) as Map<String, dynamic>;
    final calendarId = jsonBody['id'] as String?;
    debugPrint('Created new calendar: ${calendar.name}');
    return calendarId;
  }

  Future<void> deleteCalendar(String calendarId) async {
    await _msGraphAPI.deleteCalendar(calendarId: calendarId);
  }

  Future<void> updateCalendarName({
    required String calendarId,
    required String newCalendarName,
  }) async {
    final requestMap = {'name': newCalendarName};
    await _msGraphAPI.updateCalendar(
      calendarId: calendarId,
      data: jsonEncode(requestMap),
    );
  }

  Future<List<MSEvent>> fetchEventsStarting({
    DateTime? fromDate,
    String? calendarId,
  }) async {
    fromDate ??= DateTime.now().midnight.firstDateOfWeek;

    // Subtract one hour to make sure all events at the start date
    // are included
    final startDate = fromDate.subtract(const Duration(hours: 1));
    final endDate = fromDate.add(const Duration(days: 28, hours: 1));

    return _fetchEvents(
      startDate: startDate,
      endDate: endDate,
      calendarId: calendarId,
    );
  }

  Future<List<MSEvent>> fetchEventsAt(
    DateTime date, {
    String? calendarId,
  }) async {
    final startDate = date.midnight.subtract(const Duration(hours: 1));
    final endDate = date.add(const Duration(days: 1, hours: 1));

    return _fetchEvents(
      startDate: startDate,
      endDate: endDate,
      calendarId: calendarId,
    );
  }

  Future<List<MSEvent>> _fetchEvents({
    required DateTime startDate,
    required DateTime endDate,
    String? calendarId,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-ddTHH:mm');
    final startDateString = dateFormat.format(startDate);
    final endDateString = dateFormat.format(endDate);

    final Response<dynamic> response;
    if (calendarId != null) {
      response = await _msGraphAPI.calendarEventsFromCalendar(
        startDateTime: startDateString,
        endDateTime: endDateString,
        calendarId: calendarId,
      );
    } else {
      response = await _msGraphAPI.calendarEventsFromMainCalendar(
        startDateTime: startDateString,
        endDateTime: endDateString,
      );
    }

    if (!response.isSuccessful) {
      return [];
    }

    final jsonBody =
        jsonDecode(response.body.toString()) as Map<String, dynamic>;
    final eventsJson = jsonBody['value'] as List<dynamic>;
    final eventsJsonList = eventsJson.map((e) => e as Map<String, dynamic>);
    final events = eventsJsonList.map(MSEvent.fromMap).toList();
    return events;
  }

  Future<void> createEvent(MSEvent event) async {
    final jsonEvent = event.toJson();

    if (kDebugMode) {
      await _msGraphAPI.createEventInCalender(
        calendarId: Constants.testCalendarId,
        data: jsonEvent,
      );
    } else {
      await _msGraphAPI.createEvent(jsonEvent);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    if (kDebugMode) {
      await _msGraphAPI.deleteEventInCalendar(
        calendarId: Constants.testCalendarId,
        eventId: eventId,
      );
    } else {
      await _msGraphAPI.deleteEvent(eventId: eventId);
    }
  }

  Future<void> uploadBatchRequest(List<MSBatchRequest> requests) async {
    if (requests.isEmpty) return;

    // MS Graph currently supports only 20 requests per batch
    // https://learn.microsoft.com/en-us/graph/json-batching

    const batchLimit = 20;
    final sublists = partition(requests, batchLimit).toList();

    debugPrint('Uploading ${sublists.length} batch requests');

    final requestMaps = sublists.map((list) {
      return {'requests': list.map((e) => e.toMap()).toList()};
    });

    for (final map in requestMaps) {
      await _msGraphAPI.batch(jsonEncode(map));
    }
  }
}
