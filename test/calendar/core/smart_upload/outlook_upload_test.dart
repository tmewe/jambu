import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/smart_upload/outlook_upload.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/model/model.dart';
import 'package:jambu/repository/repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMSGraphRepository extends Mock implements MSGraphRepository {}

void main() {
  late User currentUser;
  late MSGraphRepository msGraphRepository;
  late DateTime date;
  late OutlookUpload outlookUpload;

  setUp(() {
    currentUser = const User(id: '0', name: 'Test User', email: 'test@d.de');
    msGraphRepository = MockMSGraphRepository();
    date = DateTime.parse('2023-03-20');
    outlookUpload = OutlookUpload(
      currentUser: currentUser,
      msEvents: [],
      attendances: [],
      msGraphRepository: msGraphRepository,
      today: date,
    );
  });

  group('OutlookUpload', () {
    group('getEventsToRemove', () {
      test(
          'returns empty list '
          'when office events are empty', () {
        // act
        final result = outlookUpload.getEventsToRemove(
          events: [],
          userAttendances: [],
        );

        // assert
        expect(result, isEmpty);
      });

      test(
          'returns office events '
          'when attendances are empty', () {
        // arrange
        final events = [MSEvent.office(date: date)];

        // act
        final result = outlookUpload.getEventsToRemove(
          events: events,
          userAttendances: [],
        );

        // assert
        expect(result, events);
      });

      test(
          'returns empty list '
          'when attendances and office events match', () {
        // arrange
        final events = [MSEvent.office(date: date)];
        final attendances = [Attendance(date: date)];

        // act
        final result = outlookUpload.getEventsToRemove(
          events: events,
          userAttendances: attendances,
        );

        // assert
        expect(result, isEmpty);
      });
    });

    group('getEventsToAdd', () {
      test(
          'returns empty list '
          'when attendances is empty', () {
        // act
        final result = outlookUpload.getEventsToAdd(
          events: [],
          userAttendances: [],
        );

        // assert
        expect(result, isEmpty);
      });

      test(
          'returns one element '
          'when attendances contain one element '
          'events are empty', () {
        // arrange
        final attendances = [Attendance(date: date)];

        // act
        final result = outlookUpload.getEventsToAdd(
          events: [],
          userAttendances: attendances,
        );

        // assert
        expect(result, [MSEvent.office(date: date)]);
      });
    });

    group('mapEventsToRequests', () {
      test(
          'returns empty list '
          'when events is empty', () {
        // act
        final result = outlookUpload.mapEventsToRequests(
          eventsToRemove: [],
          eventsToAdd: [],
        );

        // assert
        expect(result, isEmpty);
      });

      test('returns list with correct length', () {
        // arrange
        final events = List.generate(5, (index) {
          return MSEvent.office(date: date.add(Duration(days: index)));
        });

        // act
        final result = outlookUpload.mapEventsToRequests(
          eventsToRemove: events,
          eventsToAdd: events,
        );

        // assert
        expect(result, hasLength(10));
      });

      test('returns list with correct ids', () {
        // arrange
        const listLength = 5;
        final events = List.generate(listLength, (index) {
          return MSEvent.office(date: date.add(Duration(days: index)));
        });
        final expectedIds = List.generate(listLength * 2, (i) => i);

        // act
        final result = outlookUpload.mapEventsToRequests(
          eventsToRemove: events,
          eventsToAdd: events,
        );

        // assert
        final ids = result.map((e) => e.id);
        expect(ids, expectedIds);
      });
    });
  });
}
