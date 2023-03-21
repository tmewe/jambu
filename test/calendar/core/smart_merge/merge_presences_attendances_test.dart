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
        Attendance(date: date, userIds: const ['1'])
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
        Attendance(date: date, userIds: const ['1']),
        Attendance(
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
        Attendance(date: date, userIds: ['1', currentUser.id]),
        Attendance(
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
        'returns zero attendandce '
        'when there are two events and two presences '
        'that are at the same dates and in presence', () {
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
        Attendance(date: date, userIds: [currentUser.id, '1']),
        Attendance(
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
      final result = merge();

      // assert
      expect(result, expectedAttendances);
    });
  });
}
