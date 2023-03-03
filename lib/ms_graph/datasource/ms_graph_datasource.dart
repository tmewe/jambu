import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:jambu/ms_graph/api/api.dart';
import 'package:jambu/ms_graph/model/model.dart';

class MSGraphDataSource {
  MSGraphDataSource({
    required MSGraphAPI msGraphAPI,
  }) : _msGraphAPI = msGraphAPI;

  final MSGraphAPI _msGraphAPI;

  Future<Response<dynamic>> me() {
    return _msGraphAPI.me();
  }

  Future<List<MSEvent>> events() async {
    final response = await _msGraphAPI.calendarEvents(
      filter: "start/dateTime ge '2023-03-03'",
    );

    if (response.statusCode != 200) {
      return [];
    }

    debugPrint('${response.body}');

    final jsonBody =
        jsonDecode(response.body.toString()) as Map<String, dynamic>;
    final eventsJson = jsonBody['value'] as List<dynamic>;
    final eventsJsonList = eventsJson.map((e) => e as Map<String, dynamic>);
    final events = eventsJsonList.map(MSEvent.fromJson).toList();
    return events;
  }

  Future<void> create({required MSEvent event}) async {
    final jsonEvent = jsonEncode(event.toJson());
    debugPrint(jsonEvent);
    final response = await _msGraphAPI.createEvent(jsonEvent);
    debugPrint('$response');
  }
}
