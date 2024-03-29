// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ms_graph_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$MSGraphAPI extends MSGraphAPI {
  _$MSGraphAPI([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = MSGraphAPI;

  @override
  Future<Response<dynamic>> me() {
    final Uri $url = Uri.parse('/v1.0/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> photo() {
    final Uri $url = Uri.parse('/v1.0/me/photos/120x120/\$value');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> calendars({
    String select = '''id, name, hexColor''',
    int top = 50,
  }) {
    final Uri $url = Uri.parse('/v1.0/me/calendars');
    final Map<String, dynamic> $params = <String, dynamic>{
      'select': select,
      'top': top,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createCalendar(String data) {
    final Uri $url = Uri.parse('/v1.0/me/calendars');
    final Map<String, String> $headers = {
      'content-type': 'application/json',
    };
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteCalendar({required String calendarId}) {
    final Uri $url = Uri.parse('/v1.0/me/calendars/${calendarId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateCalendar({
    required String calendarId,
    required String data,
  }) {
    final Uri $url = Uri.parse('/v1.0/me/calendars/${calendarId}');
    final Map<String, String> $headers = {
      'content-type': 'application/json',
    };
    final $body = data;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> calendarEventsFromMainCalendar({
    required String startDateTime,
    required String endDateTime,
    String select = _eventsSelect,
    int top = _eventsLimit,
  }) {
    final Uri $url = Uri.parse('/v1.0/me/calendar/calendarView');
    final Map<String, dynamic> $params = <String, dynamic>{
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'select': select,
      'top': top,
    };
    final Map<String, String> $headers = {
      'Prefer': 'outlook.timezone = "Europe/Berlin"',
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> calendarEventsFromCalendar({
    required String startDateTime,
    required String endDateTime,
    required String calendarId,
    String select = _eventsSelect,
    int top = _eventsLimit,
  }) {
    final Uri $url = Uri.parse('/v1.0/me/calendars/${calendarId}/calendarView');
    final Map<String, dynamic> $params = <String, dynamic>{
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'select': select,
      'top': top,
    };
    final Map<String, String> $headers = {
      'Prefer': 'outlook.timezone = "Europe/Berlin"',
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createEvent(String data) {
    final Uri $url = Uri.parse('/v1.0/me/calendar/events');
    final Map<String, String> $headers = {
      'content-type': 'application/json',
    };
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteEvent({required String eventId}) {
    final Uri $url = Uri.parse('/v1.0/me/calendar/events/${eventId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createEventInCalender({
    required String calendarId,
    required String data,
  }) {
    final Uri $url = Uri.parse('/v1.0/me/calendars/${calendarId}/events');
    final Map<String, String> $headers = {
      'content-type': 'application/json',
    };
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteEventInCalendar({
    required String calendarId,
    required String eventId,
  }) {
    final Uri $url =
        Uri.parse('/v1.0/me/calendars/${calendarId}/events/${eventId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> batch(String data) {
    final Uri $url = Uri.parse('/v1.0/\$batch');
    final Map<String, String> $headers = {
      'content-type': 'application/json',
    };
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
