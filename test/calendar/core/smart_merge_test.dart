import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/model/model.dart';
import 'package:jambu/ms_graph/model/ms_event_attendee.dart';

void main() {
  const currentUser = User(id: '0', name: 'Test User', email: 't@gmail.com');

  group('SmartMerge', () {
    test(
        'returns zweo attendandce '
        'when there are two fs events and two ms events '
        'that are at the same dates and not in presence', () {
      // arrange
      final date = DateTime.parse('2023-03-20');

      final fsAttendances = [
        Attendance(date: date, userIds: [currentUser.id]),
        Attendance(
          date: date.add(const Duration(days: 1)),
          userIds: [currentUser.id],
        ),
      ];

      final msEvents = [
        _oofEvent(date: date),
        _oofEvent(date: date.add(const Duration(days: 1))),
      ];

      final smartMerge = SmartMerge(
        currentUser: currentUser,
        msEvents: msEvents,
        firestoreAttendances: fsAttendances,
      );

      // act
      final result = smartMerge();

      // assert
      expect(result, <Attendance>[]);
    });

    test(
        'returns two attendandce '
        'when there are two fs events and two ms events '
        'that are at the same dates and in presence', () {
      // arrange
      final date = DateTime.parse('2023-03-20');

      final fsAttendances = [
        Attendance(date: date, userIds: const ['1']),
        Attendance(
          date: date.add(const Duration(days: 1)),
          userIds: const ['2'],
        ),
      ];

      final msEvents = [
        _presenceEvent(date: date),
        _presenceEvent(date: date.add(const Duration(days: 1))),
      ];

      final smartMerge = SmartMerge(
        currentUser: currentUser,
        msEvents: msEvents,
        firestoreAttendances: fsAttendances,
      );

      final expectedAttendances = [
        Attendance(date: date, userIds: ['1', currentUser.id]),
        Attendance(
          date: date.add(const Duration(days: 1)),
          userIds: ['2', currentUser.id],
        ),
      ];

      // act
      final result = smartMerge();

      // assert
      expect(result, expectedAttendances);
    });

    test(
        'returns four attendandce '
        'when there are two fs events and two ms events '
        'that are not overlapping', () {
      // arrange
      final date = DateTime.parse('2023-03-20');

      final fsAttendances = [
        Attendance(date: date, userIds: [currentUser.id, '1']),
        Attendance(
          date: date.add(const Duration(days: 1)),
          userIds: [currentUser.id, '2'],
        ),
      ];

      final msEvents = [
        _presenceEvent(date: date.add(const Duration(days: 2))),
        _presenceEvent(date: date.add(const Duration(days: 3))),
      ];

      final smartMerge = SmartMerge(
        currentUser: currentUser,
        msEvents: msEvents,
        firestoreAttendances: fsAttendances,
      );

      final expectedAttendances = [
        ...fsAttendances,
        Attendance(
          date: date.add(const Duration(days: 2)),
          userIds: [currentUser.id],
        ),
        Attendance(
          date: date.add(const Duration(days: 3)),
          userIds: [currentUser.id],
        ),
      ];

      // act
      final result = smartMerge();

      // assert
      expect(result, expectedAttendances);
    });

    group('Microsoft events are empty', () {
      const msEvents = <MSEvent>[];

      test('returns firestore attendances', () async {
        // arrange
        final fsAttendances = _attendances;
        final smartMerge = SmartMerge(
          currentUser: currentUser,
          msEvents: msEvents,
          firestoreAttendances: fsAttendances,
        );

        // act
        final result = smartMerge();

        // assert
        expect(result, fsAttendances);
      });
    });

    group('Firestore attendances are empty', () {
      const fsAttendances = <Attendance>[];

      test(
          'returns empty attendandces '
          'when event is all day and status is oof', () {
        // arrange
        final date = DateTime.parse('2023-03-20');
        final msEvent = _oofEvent(date: date);
        final smartMerge = SmartMerge(
          currentUser: currentUser,
          msEvents: [msEvent],
          firestoreAttendances: fsAttendances,
        );

        // act
        final result = smartMerge();

        // assert
        expect(result, <Attendance>[]);
      });

      test(
          'returns one attendandce '
          'when there is one event '
          'that has no online meeting and more than two attendees', () {
        // arrange
        final date = DateTime.parse('2023-03-20');
        final msEvent = _presenceEvent(date: date);
        final smartMerge = SmartMerge(
          currentUser: currentUser,
          msEvents: [msEvent],
          firestoreAttendances: fsAttendances,
        );
        final attendance = Attendance(date: date, userIds: [currentUser.id]);

        // act
        final result = smartMerge();

        // assert
        expect(result, [attendance]);
      });

      test(
          'returns empty attendandces '
          'when there are two events '
          'one oof and one in presence at the same date', () {
        // arrange
        final date = DateTime.parse('2023-03-20');
        final oofEvent = _oofEvent(date: date);
        final presenceEvent = _presenceEvent(date: date);
        final smartMerge = SmartMerge(
          currentUser: currentUser,
          msEvents: [presenceEvent, oofEvent],
          firestoreAttendances: fsAttendances,
        );
        // final attendance = Attendance(date: date, userIds: [currentUser.id]);

        // act
        final result = smartMerge();

        // assert
        expect(result, <Attendance>[]);
      });

      test(
          'returns two attendandces '
          'when event goes on for two days', () {
        // arrange
        final startDate = DateTime.parse('2023-03-20');
        const duration = Duration(days: 1);
        final presenceEvent = _presenceEvent(
          date: startDate,
          duration: duration,
        );
        final smartMerge = SmartMerge(
          currentUser: currentUser,
          msEvents: [presenceEvent],
          firestoreAttendances: fsAttendances,
        );

        // act
        final result = smartMerge();

        // assert
        expect(result, [
          Attendance(date: startDate, userIds: [currentUser.id]),
          Attendance(date: startDate.add(duration), userIds: [currentUser.id]),
        ]);
      });
    });
  });
}

List<Attendance> get _attendances {
  return [
    Attendance(date: DateTime.parse('2023-03-20'), userIds: const ['1']),
    Attendance(date: DateTime.parse('2023-03-21'), userIds: const ['2']),
  ];
}

MSEvent _oofEvent({required DateTime date}) {
  final msDate = MSDate(date: date, timeZone: '');
  return MSEvent(
    subject: 'Test',
    isAllDay: true,
    isOnlineMeeting: false,
    start: msDate,
    end: msDate,
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
  );
}
