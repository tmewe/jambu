// ignore_for_file: use_raw_strings

import 'package:chopper/chopper.dart';

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

  @Get(path: 'me/calendar/events')
  Future<Response<dynamic>> calendarEvents({
    @Query() required String filter,
    @Query() String select =
        '''subject, showAs, isOnlineMeeting, start, end, location, responseStatus, isAllDay''',
  });

  @Post(
    path: 'me/calendar/events',
    headers: {'content-type': 'application/json'},
  )
  Future<Response<dynamic>> createEvent(@Body() String data);

  static MSGraphAPI create([ChopperClient? client]) => _$MSGraphAPI(client);
}
