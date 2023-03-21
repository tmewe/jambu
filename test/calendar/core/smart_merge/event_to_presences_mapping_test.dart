import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/smart_merge/event_to_presences_mapping.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/ms_graph/model/model.dart';

void main() {
  group('EventToPresenceMapping', () {
    late DateTime date;

    setUp(() {
      date = DateTime.parse('2023-03-20');
    });

    test(
        'returns one element where isPresent is false '
        'when event is whole day oof', () {
      // arrange
      final event = _oofEvent(date: date);
      final mapping = EventToPresencesMapping(event: event);

      // act
      final result = mapping();

      // assert
      expect(result, [Presence(date: date, isPresent: false)]);
    });

    test(
        'returns one element where isPresent is true '
        'when event is in presence', () {
      // arrange
      final event = _presenceEvent(date: date);
      final mapping = EventToPresencesMapping(event: event);

      // act
      final result = mapping();

      // assert
      expect(result, [Presence(date: date, isPresent: true)]);
    });

    test(
        'returns five element where isPresent is false '
        'when event oof for six days', () {
      // arrange
      const duration = Duration(days: 4);
      final event = _oofEvent(date: date, duration: duration);
      final mapping = EventToPresencesMapping(event: event);

      final expected = List.generate(5, (i) {
        return Presence(date: date.add(Duration(days: i)), isPresent: false);
      });

      // act
      final result = mapping();

      // assert
      expect(result, expected);
    });
  });
}

MSEvent _oofEvent({
  required DateTime date,
  Duration duration = Duration.zero,
}) {
  final startDate = MSDate(date: date, timeZone: '');
  final endDate = MSDate(date: date.add(duration), timeZone: '');
  return MSEvent(
    subject: 'Test',
    isAllDay: true,
    isOnlineMeeting: false,
    start: startDate,
    end: endDate,
    showAs: EventStatus.oof,
  );
}

MSEvent _presenceEvent({
  required DateTime date,
  Duration duration = Duration.zero,
}) {
  final startDate = MSDate(date: date, timeZone: '');
  final endDate = MSDate(date: date.add(duration), timeZone: '');
  return MSEvent(
    subject: 'Test',
    isAllDay: false,
    isOnlineMeeting: false,
    start: startDate,
    end: endDate,
    showAs: EventStatus.oof,
    attendees: List.generate(3, (_) => MSEventAttendee(type: 'required')),
    responseStatus: const MSEventResponseStatus(
      response: ResponseStatus.accepted,
    ),
  );
}
