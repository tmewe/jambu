import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/smart_merge/merge_presences_attendances.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/model/model.dart';

void main() {
  group('MergePresencesAttendances', () {
    late User currentUser;
    late DateTime date;

    setUp(() {
      date = DateTime.parse('2023-03-20');
      currentUser = const User(
        id: '0',
        name: 'Test User',
        email: 't@gmail.com',
      );
    });

    test(
        'returns attendances '
        'when presences are empty', () async {
      // arrange
      final attendances = [
        Attendance.attending(date: date, userIds: const ['1'])
      ];
      final merge = MergePresencesAttendances(
        presences: [],
        attendances: attendances,
        currentUser: currentUser,
      );

      // act
      final result = merge();

      // assert
      expect(result, attendances);
    });

    test(
        'returns two attendandce '
        'when there are two events and two presences '
        'that are at the same dates and in presence', () {
      // arrange
      final attendances = [
        Attendance.attending(date: date, userIds: const ['1']),
        Attendance.attending(
          date: date.add(const Duration(days: 1)),
          userIds: const ['2'],
        ),
      ];

      final presences = [
        Presence(date: date, isPresent: true),
        Presence(date: date.add(const Duration(days: 1)), isPresent: true),
      ];

      final merge = MergePresencesAttendances(
        presences: presences,
        attendances: attendances,
        currentUser: currentUser,
      );

      final expectedAttendances = [
        Attendance.attending(date: date, userIds: ['1', currentUser.id]),
        Attendance.attending(
          date: date.add(const Duration(days: 1)),
          userIds: ['2', currentUser.id],
        ),
      ];

      // act
      final result = merge();

      // assert
      expect(result, expectedAttendances);
    });

    test(
        'returns zero attendandces '
        'when there are two attendances and two presences '
        'that are at the same dates and not in presence', () {
      // arrange
      final attendances = [
        Attendance(
          date: date,
        ),
        Attendance(date: date.add(const Duration(days: 1))),
      ];

      final presences = [
        Presence(date: date, isPresent: false),
        Presence(date: date.add(const Duration(days: 1)), isPresent: false),
      ];

      final merge = MergePresencesAttendances(
        presences: presences,
        attendances: attendances,
        currentUser: currentUser,
      );

      // act
      final result = merge();

      // assert
      expect(result, <Attendance>[]);
    });

    test(
        'returns four attendandces '
        'when there are two events and two attendance '
        'that are not at the same dates', () {
      // arrange
      final attendances = [
        Attendance.attending(date: date, userIds: [currentUser.id, '1']),
        Attendance.attending(
          date: date.add(const Duration(days: 1)),
          userIds: [currentUser.id, '2'],
        ),
      ];

      final presences = [
        Presence(date: date.add(const Duration(days: 2)), isPresent: true),
        Presence(date: date.add(const Duration(days: 3)), isPresent: true),
      ];

      final merge = MergePresencesAttendances(
        presences: presences,
        attendances: attendances,
        currentUser: currentUser,
      );

      final expectedAttendances = [
        ...attendances,
        Attendance.attending(
          date: date.add(const Duration(days: 2)),
          userIds: [currentUser.id],
        ),
        Attendance.attending(
          date: date.add(const Duration(days: 3)),
          userIds: [currentUser.id],
        ),
      ];

      // act
      final result = merge();

      // assert
      expect(result, expectedAttendances);
    });

    group('Reasons', () {
      test(
          'returns attendance that contains reason '
          'when presence contains reason', () {
        // arrange
        const presentReason = 'Office event';
        const absentReason = 'OOF';
        final presences = [
          Presence(date: date, isPresent: true, reason: presentReason),
          Presence(
            date: date.add(const Duration(days: 1)),
            isPresent: false,
            reason: absentReason,
          ),
        ];

        final merge = MergePresencesAttendances(
          presences: presences,
          attendances: [],
          currentUser: currentUser,
        );

        // act
        final result = merge();

        // assert
        expect(result, hasLength(2));

        final presentAttendance = result[0].present[0];
        final absentAttendance = result[1].absent[0];

        expect(presentAttendance, isNotNull);
        expect(absentAttendance, isNotNull);
        expect(presentAttendance.reason, presentReason);
        expect(absentAttendance.reason, absentReason);
      });

      test(
          'returns attendance that contains one absent entry '
          'and no present entries '
          'when presence is false and contains reason '
          'and attendances contains one present entry '
          'which isAttending is true at same date', () {
        // arrange
        final presences = [
          Presence(date: date, isPresent: false, reason: 'OOF'),
        ];
        final attendances = [
          Attendance(date: date, present: [Entry(userId: currentUser.id)]),
        ];

        final merge = MergePresencesAttendances(
          presences: presences,
          attendances: attendances,
          currentUser: currentUser,
        );

        // act
        final result = merge();

        // assert
        expect(result, hasLength(1));

        final absentAttendance = result[0];

        expect(absentAttendance, isNotNull);
        expect(absentAttendance.absent, hasLength(1));
        expect(absentAttendance.present, isEmpty);
      });

      test(
          'returns attendance that contains one present entry '
          'and no absent entries '
          'when presence is true '
          'and attendances contains one absent entry '
          'which isAttending is false at same date', () {
        // arrange
        final presences = [
          Presence(date: date, isPresent: true, reason: 'Termin'),
        ];
        final attendances = [
          Attendance(date: date, absent: [Entry(userId: currentUser.id)]),
        ];

        final merge = MergePresencesAttendances(
          presences: presences,
          attendances: attendances,
          currentUser: currentUser,
        );

        // act
        final result = merge();

        // assert
        expect(result, hasLength(1));

        final presentAttendance = result[0];

        expect(presentAttendance, isNotNull);
        expect(presentAttendance.present, hasLength(1));
        expect(presentAttendance.absent, isEmpty);
      });

      test(
          'Removes reason '
          'when presence at date has no reason', () {
        // arrange
        final presences = [
          Presence(
            date: date.add(const Duration(days: 1)),
            isPresent: false,
            reason: 'Urlaub',
          ),
        ];
        final attendances = [
          Attendance(
            date: date,
            absent: [Entry(userId: currentUser.id, reason: 'Urlaub')],
          ),
        ];

        final merge = MergePresencesAttendances(
          presences: presences,
          attendances: attendances,
          currentUser: currentUser,
        );

        // act
        final result = merge();

        // assert
        expect(result, hasLength(2));
        expect(result[0].absent[0].reason, isNull);
        expect(result[1].absent[0].reason, 'Urlaub');
      });
    });
  });
}
