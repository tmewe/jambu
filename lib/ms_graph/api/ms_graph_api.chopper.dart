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
  Future<Response<dynamic>> calendarEvents({
    required String filter,
    String select =
        '''subject, showAs, isOnlineMeeting, start, end, location, responseStatus, isAllDay''',
  }) {
    final Uri $url = Uri.parse('/v1.0/me/calendar/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'filter': filter,
      'select': select,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
