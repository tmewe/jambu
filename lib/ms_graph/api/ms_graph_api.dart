// ignore_for_file: use_raw_strings

import 'package:chopper/chopper.dart';
import 'package:jambu/constants.dart';

part 'ms_graph_api.chopper.dart';

@ChopperApi(baseUrl: '/v1.0')
abstract class MSGraphAPI extends ChopperService {
  @Get(path: '/me')
  Future<Response<dynamic>> me();

  @Get(path: r'/me/photos/120x120/\$value')
  Future<Response<dynamic>> photo();

  @Get(path: 'me/calendars')
  Future<Response<dynamic>> calendars({
    @Query() String select = '''id, name, hexColor''',
  });

  @Post(
    path: 'me/calendars',
    headers: {'content-type': 'application/json'},
  )
  Future<Response<dynamic>> createCalendar(@Body() String data);

  @Delete(path: 'me/calendars/{id}')
  Future<Response<dynamic>> deleteCalendar({
    @Path('id') required String calendarId,
  });

  @Patch(
    path: 'me/calendars/{id}',
    headers: {'content-type': 'application/json'},
  )
  Future<Response<dynamic>> updateCalendar({
    @Path('id') required String calendarId,
    @Body() required String data,
  });

  @Get(
    path: 'me/calendar/events',
    headers: {'Prefer': 'outlook.timezone = "${Constants.germanTimeZone}"'},
  )
  Future<Response<dynamic>> calendarEventsFromMainCalendar({
    @Query() required String filter,
    @Query() String select = 'subject, showAs, isOnlineMeeting, start, '
        'end, location, responseStatus, isAllDay, attendees',
    @Query() int top = 100,
  });

  @Get(
    path: 'me/calendars/{id}/events',
    headers: {'Prefer': 'outlook.timezone = "${Constants.germanTimeZone}"'},
  )
  Future<Response<dynamic>> calendarEventsFromCalendar({
    @Path('id') required String calendarId,
    @Query() required String filter,
    @Query() String select = 'subject, showAs, isOnlineMeeting, start, '
        'end, location, responseStatus, isAllDay, attendees',
    @Query() int top = 100,
  });

  @Post(
    path: 'me/calendar/events',
    headers: {'content-type': 'application/json'},
  )
  Future<Response<dynamic>> createEvent(@Body() String data);

  @Delete(path: 'me/calendar/events/{eventId}')
  Future<Response<dynamic>> deleteEvent({
    @Path('eventId') required String eventId,
  });

  // TODO(tim): Just for testing - REMOVE
  @Post(
    path: 'me/calendars/{id}/events',
    headers: {'content-type': 'application/json'},
  )
  Future<Response<dynamic>> createEventInCalender({
    @Path('id') required String calendarId,
    @Body() required String data,
  });

  // TODO(tim): Just for testing - REMOVE
  @Delete(path: 'me/calendars/{calendarId}/events/{eventId}')
  Future<Response<dynamic>> deleteEventInCalendar({
    @Path('calendarId') required String calendarId,
    @Path('eventId') required String eventId,
  });

  @Post(
    path: r'\$batch',
    headers: {'content-type': 'application/json'},
  )
  Future<Response<dynamic>> batch(@Body() String data);

  static MSGraphAPI create([ChopperClient? client]) => _$MSGraphAPI(client);
}
