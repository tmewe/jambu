import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/model/model.dart';

void main() {
  group('CalendarMapping', () {
    late DateTime date;
    late User user;
    late List<User> testUsers;

    setUp(() {
      date = DateTime.parse('2023-03-20');
      user = const User(id: '-1', name: 'Test User', email: 'test@user.de');
      testUsers = List.generate(
        5,
        (index) => User(
          id: index.toString(),
          name: index.toString(),
          email: index.toString(),
        ),
      );
    });

    test('returns list with four elements', () {
      // arrange
      final mapping = CalendarMapping(
        currentUser: user,
        attendances: [],
        users: [],
        today: date,
      );

      // act
      final result = mapping();

      // assert
      expect(result, hasLength(4));
    });

    test(
        'returns list where every day contains no users '
        'when attendances is empty', () {
      // arrange
      final mapping = CalendarMapping(
        currentUser: user,
        attendances: [],
        users: [],
        today: date,
      );

      // act
      final result = mapping();

      // assert
      for (final week in result) {
        for (final day in week.days) {
          expect(day.users, isEmpty);
        }
      }
    });

    test(
        'returns list where with correct users '
        'when attendances is not empty', () {
      // arrange
      final date1 = DateTime.parse('2023-03-20');
      final date2 = DateTime.parse('2023-03-21');
      final attendances = [
        Attendance(date: date1, userIds: [testUsers[0].id]),
        Attendance(date: date2, userIds: [testUsers[1].id]),
      ];
      final mapping = CalendarMapping(
        currentUser: user,
        attendances: attendances,
        users: testUsers,
        today: date,
      );

      // act
      final result = mapping();

      // assert
      final day1 = result.first.days[0];
      final userAtDay1 = testUsers[0];
      expect(
        day1.users,
        [CalendarUser(id: userAtDay1.id, name: userAtDay1.name)],
      );

      final day2 = result.first.days[1];
      final userAtDay2 = testUsers[1];
      expect(
        day2.users,
        [CalendarUser(id: userAtDay2.id, name: userAtDay2.name)],
      );
    });

    test(
        'returns list where with attendances '
        'when attendances contain current user', () {
      // arrange
      final attendances = List.generate(
        2,
        (i) => Attendance(
          date: date.add(Duration(days: i)),
          userIds: [user.id, '2', '3'],
        ),
      );
      final mapping = CalendarMapping(
        currentUser: user,
        attendances: attendances,
        users: testUsers,
        today: date,
      );

      // act
      final result = mapping();

      // assert
      final day1 = result.first.days[0];
      expect(day1.isUserAttending, isTrue);

      final day2 = result.first.days[1];
      expect(day2.isUserAttending, isTrue);
    });
  });
}
