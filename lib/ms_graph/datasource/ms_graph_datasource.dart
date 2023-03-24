import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/ms_graph/api/api.dart';
import 'package:jambu/ms_graph/model/model.dart';

class MSGraphDataSource {
  MSGraphDataSource({
    required MSGraphAPI msGraphAPI,
  }) : _msGraphAPI = msGraphAPI;

  final MSGraphAPI _msGraphAPI;

  Future<MSUser?> me() async {
    final response = await _msGraphAPI.me();

    if (response.statusCode != 200) {
      return null;
    }

    return MSUser.fromJson(response.body.toString());
  }

  Future<Uint8List?> profilePhoto() async {
    final response = await _msGraphAPI.photo();

    if (response.statusCode != 200) {
      return null;
    }

    return response.bodyBytes;
  }

  Future<List<MSCalendar>> calendars() async {
    final response = await _msGraphAPI.calendars();

    if (response.statusCode != 200) {
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

  Future<void> createCalendar(MSCalendar calendar) async {
    final jsonCalendar = calendar.toJson();
    await _msGraphAPI.createCalendar(jsonCalendar);
  }

  Future<List<MSEvent>> eventsFrom({DateTime? fromDate}) async {
    fromDate ??= DateTime.now();

    // Subtract one hour to make sure all events at the start date
    // are included
    final startDate = fromDate.midnight.subtract(const Duration(hours: 1));
    final endDate = fromDate.add(const Duration(days: 28, hours: 1));

    return _fetchEvents(startDate: startDate, endDate: endDate);
  }

  Future<List<MSEvent>> eventsAt({required DateTime date}) async {
    final startDate = date.midnight.subtract(const Duration(hours: 1));
    final endDate = date.add(const Duration(days: 1, hours: 1));

    return _fetchEvents(startDate: startDate, endDate: endDate);
  }

  Future<List<MSEvent>> _fetchEvents({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final startDateString = DateFormat('yyyy-MM-ddTHH:mm').format(startDate);
    final endDateString = DateFormat('yyyy-MM-ddTHH:mm').format(endDate);
    final filter = "start/dateTime ge '$startDateString' "
        "and end/dateTime le '$endDateString'";

    final response = await _msGraphAPI.calendarEvents(filter: filter);

    if (response.statusCode != 200) {
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
    await _msGraphAPI.createEvent(jsonEvent);
  }

  Future<void> deleteEvent(String eventId) async {
    await _msGraphAPI.deleteEvent(id: eventId);
  }

  Future<void> uploadBatchRequest(List<MSBatchRequest> requests) async {
    if (requests.isEmpty) return;

    final requestMap = {
      'requests': requests.map((e) => e.toMap()).toList(),
    };
    await _msGraphAPI.batch(jsonEncode(requestMap));
  }
}
