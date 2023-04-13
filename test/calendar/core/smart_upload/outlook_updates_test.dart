import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/smart_upload/outlook_updates.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

void main() {
  group('OutlookUpdates', () {
    late DateTime date;

    setUp(() {
      date = DateTime.parse('2023-04-10');
    });

    group('eventsToRemove', () {
      test(
          'is empty '
          'when office events are empty', () {
        // arrange
        final updates = OutlookUpdates(
          officeEvents: [],
          userAttendances: [],
        );
        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, isEmpty);
      });

      test(
          'is empty '
          'when attendances and office events match', () {
        // arrange
        final events = [MSEvent.office(date: date)];
        final attendances = [Attendance(date: date)];

        final updates = OutlookUpdates(
          officeEvents: events,
          userAttendances: attendances,
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, isEmpty);
      });

      test(
          'returns office events '
          'when attendances are empty', () {
        // arrange
        final events = [MSEvent.office(date: date)];

        final updates = OutlookUpdates(
          officeEvents: events,
          userAttendances: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, events);
      });

      test('contains duplicate events', () {
        // arrange
        final duplicateEvent = MSEvent.office(date: date);
        final attendance = Attendance(date: date);

        final updates = OutlookUpdates(
          officeEvents: [duplicateEvent, duplicateEvent],
          userAttendances: [attendance],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, [duplicateEvent]);
      });
    });

    group('eventsToAdd', () {
      test(
          'is empty '
          'when attendances is empty', () {
        // arrange
        final updates = OutlookUpdates(
          officeEvents: [],
          userAttendances: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, isEmpty);
      });

      test(
          'returns one element '
          'when attendances contain one element '
          'and events are empty', () {
        // arrange
        final attendances = [Attendance(date: date)];

        final updates = OutlookUpdates(
          officeEvents: [],
          userAttendances: attendances,
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, [MSEvent.office(date: date)]);
      });
    });
  });
}
