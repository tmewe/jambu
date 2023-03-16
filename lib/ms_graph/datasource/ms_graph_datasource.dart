import 'dart:convert';
import 'dart:typed_data';

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
    final calendars = calendarsJsonList.map(MSCalendar.fromJson).toList();
    return calendars;
  }

  Future<void> createCalendar(MSCalendar calendar) async {
    final jsonCalendar = jsonEncode(calendar.toJson());
    await _msGraphAPI.createCalendar(jsonCalendar);
  }

  Future<List<MSEvent>> events() async {
    final response = await _msGraphAPI.calendarEvents(
      filter: "start/dateTime ge '2023-03-03'",
    );

    if (response.statusCode != 200) {
      return [];
    }

    final jsonBody =
        jsonDecode(response.body.toString()) as Map<String, dynamic>;
    final eventsJson = jsonBody['value'] as List<dynamic>;
    final eventsJsonList = eventsJson.map((e) => e as Map<String, dynamic>);
    final events = eventsJsonList.map(MSEvent.fromJson).toList();
    return events;
  }

  Future<void> createEvent(MSEvent event) async {
    final jsonEvent = jsonEncode(event.toJson());
    await _msGraphAPI.createEvent(jsonEvent);
  }
}
