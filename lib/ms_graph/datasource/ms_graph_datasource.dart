import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
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

  Future<List<MSEvent>> events({DateTime? fromDate}) async {
    var filter = '';
    if (fromDate != null) {
      // Date format 2023-03-03
      final dateString = DateFormat('yyyy-MM-dd').format(fromDate);
      filter = "start/dateTime ge '$dateString'";
    }
    final response = await _msGraphAPI.calendarEvents(
      filter: filter,
    );

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
}
