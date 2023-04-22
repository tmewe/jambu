import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

void main() {
  group('MSEvent', () {
    late MSEvent event;

    setUp(() {
      final date = DateTime.parse('2023-04-17');
      event = MSEvent.office(date: date);
    });
    group('isOfficeEvent', () {
      setUp(() {
        event = event.copyWith(
          isOnlineMeeting: false,
          isCancelled: false,
          attendees: [MSEventAttendee(type: 'required')],
          location: MSEventLocation(displayName: 'Raum Bandung'),
          responseStatus: const MSEventResponseStatus(
            response: ResponseStatus.organizer,
          ),
        );
      });

      test('returns true when all conditions are met', () {
        // act
        final result = event.isOfficeEvent;

        // assert
        expect(result, isTrue);
      });

      test('returns false when cancelled is true', () {
        // arrange
        final testEvent = event.copyWith(isCancelled: true);

        // act
        final result = testEvent.isOfficeEvent;

        // assert
        expect(result, isFalse);
      });

      test('returns false when event is an online meeting', () {
        // arrange
        final testEvent = event.copyWith(isOnlineMeeting: true);

        // act
        final result = testEvent.isOfficeEvent;

        // assert
        expect(result, isFalse);
      });

      test('returns false when no required attendees', () {
        // arrange
        final testEvent = event.copyWith(attendees: []);

        // act
        final result = testEvent.isOfficeEvent;

        // assert
        expect(result, isFalse);
      });

      test('returns false when declined', () {
        // arrange
        final testEvent = event.copyWith(
          responseStatus: const MSEventResponseStatus(
            response: ResponseStatus.declined,
          ),
        );

        // act
        final result = testEvent.isOfficeEvent;

        // assert
        expect(result, isFalse);
      });

      test('returns false when location is an url', () {
        // arrange
        final testEvent = event.copyWith(
          location: MSEventLocation(displayName: 'live.jambit.com'),
        );

        // act
        final result = testEvent.isOfficeEvent;

        // assert
        expect(result, isFalse);
      });

      test(
          'returns false '
          'when location is not empty and not a meeting room', () {
        // arrange
        final testEvent = event.copyWith(
          location: MSEventLocation(displayName: 'Hotel zum Test'),
        );

        // act
        final result = testEvent.isOfficeEvent;

        // assert
        expect(result, isFalse);
      });
    });

    group('isWholeDayOOF', () {
      test('returns false when event is not all day', () {
        // arrange
        final testEvent = event.copyWith(isAllDay: false);

        // act
        final result = testEvent.isAllDayOOF;

        // assert
        expect(result, isFalse);
      });

      test('returns false when showsAs is not oof', () {
        // arrange
        final testEvent = event.copyWith(showAs: EventStatus.free);

        // act
        final result = testEvent.isAllDayOOF;

        // assert
        expect(result, isFalse);
      });

      test('returns true when all conditions are met', () {
        // arrange
        final testEvent = event.copyWith(
          isAllDay: true,
          showAs: EventStatus.oof,
        );

        // act
        final result = testEvent.isAllDayOOF;

        // assert
        expect(result, isTrue);
      });
    });
  });
}
