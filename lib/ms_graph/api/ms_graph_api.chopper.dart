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
  Future<Response<dynamic>> calendars(
      {String select = '''id, name, hexColor'''}) {
    final Uri $url = Uri.parse('/v1.0/me/calendars');
    final Map<String, dynamic> $params = <String, dynamic>{'select': select};
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
  Future<Response<dynamic>> calendarEvents({
    required String filter,
    String select = 'subject, showAs, isOnlineMeeting, start, '
        'end, location, responseStatus, isAllDay, attendees',
    int top = 100,
  }) {
    final Uri $url = Uri.parse(
        '/v1.0/me/calendars/AAMkAGYwY2Y0MWM4LWE2MzItNDk5Ny05NzIzLWFjNjUwZjI3Y2UwYwBGAAAAAABd4EEhe61iSIEnLzkh3SdoBwDnm8A17Q_oQ41X7GXJE69AAAAAAAEGAADnm8A17Q_oQ41X7GXJE69AAACKlQf_AAA=/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'filter': filter,
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
  Future<Response<dynamic>> createEvent(String data) {
    final Uri $url = Uri.parse(
        '/v1.0/me/calendars/AAMkAGYwY2Y0MWM4LWE2MzItNDk5Ny05NzIzLWFjNjUwZjI3Y2UwYwBGAAAAAABd4EEhe61iSIEnLzkh3SdoBwDnm8A17Q_oQ41X7GXJE69AAAAAAAEGAADnm8A17Q_oQ41X7GXJE69AAACKlQf_AAA=/events');
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
  Future<Response<dynamic>> deleteEvent({required String id}) {
    final Uri $url = Uri.parse(
        '/v1.0/me/calendars/AAMkAGYwY2Y0MWM4LWE2MzItNDk5Ny05NzIzLWFjNjUwZjI3Y2UwYwBGAAAAAABd4EEhe61iSIEnLzkh3SdoBwDnm8A17Q_oQ41X7GXJE69AAAAAAAEGAADnm8A17Q_oQ41X7GXJE69AAACKlQf_AAA=/events');
    final Map<String, dynamic> $params = <String, dynamic>{'id': id};
    final Map<String, String> $headers = {
      'content-type': 'application/json',
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
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
