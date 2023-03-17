import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/calendar_filtering.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/util/util.dart';

void main() {
  group('CalendarFiltering', () {
    // late final List<String> tags;
    late List<CalendarUser> users;
    late List<CalendarWeek> weeks;

    setUp(() {
      final tags = _createTags();
      users = _createUsers(tags: tags);
      weeks = _createWeeks(users: users);
    });

    test('returns unfiltered result if search & tags are empty', () {
      // arrange
      const filter = CalendarFilter();
      final sut = CalendarFiltering(filter: filter, weeks: weeks);

      // act
      final result = sut.call();

      // assert
      expect(result, weeks);
    });

    test('returns correct result if searching for 5', () {
      // arrange
      const userIndex = 5;
      const search = '$userIndex';
      final filterdWeeks = _createWeeks(users: [users[userIndex]]);
      const filter = CalendarFilter(search: search);
      final sut = CalendarFiltering(filter: filter, weeks: weeks);

      // act
      final result = sut.call();

      // assert
      expect(result, filterdWeeks);
    });

    test('returns correct result if searching for tag Bier', () {
      // arrange
      const filterTag = 'Bier';
      final usersWithTagBier = users.where((u) {
        return u.tags.contains(filterTag);
      }).toList();
      final filterdWeeks = _createWeeks(users: usersWithTagBier);

      const filter = CalendarFilter(tags: [filterTag]);
      final sut = CalendarFiltering(filter: filter, weeks: weeks);

      // act
      final result = sut.call();

      // assert
      expect(result, filterdWeeks);
    });

    test('returns correct result if searching for 5 and tag Bier', () {
      // arrange
      const userIndex = 5;
      const search = '$userIndex';
      const filterTag = 'Bier';
      final usersWithTagBier = users.where((u) {
        return u.tags.contains(filterTag) && u.name.contains(search);
      }).toList();
      final filterdWeeks = _createWeeks(users: usersWithTagBier);

      const filter = CalendarFilter(search: search, tags: [filterTag]);
      final sut = CalendarFiltering(filter: filter, weeks: weeks);

      // act
      final result = sut.call();

      // assert
      expect(result, filterdWeeks);
    });
  });
}

List<CalendarWeek> _createWeeks({
  required List<CalendarUser> users,
}) {
  final month = MonthFromDate(DateTime.parse('2023-03-17'));
  final weeks = <CalendarWeek>[];

  for (final week in month.weeks) {
    final days = <CalendarDay>[];
    for (final date in week.workingDays) {
      days.add(CalendarDay(date: date, isUserAttending: false, users: users));
    }
    weeks.add(CalendarWeek(days: days));
  }

  return weeks;
}

List<CalendarUser> _createUsers({
  required List<String> tags,
}) {
  final users = <CalendarUser>[];
  for (var i = 0; i < 10; i++) {
    final tagIndex = i % tags.length == 0 ? 0 : 1;
    users.add(
      CalendarUser(
        id: '$i',
        name: '$i',
        tags: [tags[tagIndex]],
      ),
    );
  }
  return users;
}

List<String> _createTags() {
  return ['Bier', 'Darts'];
}
