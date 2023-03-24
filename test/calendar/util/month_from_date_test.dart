import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/util/month_from_date.dart';
import 'package:jambu/calendar/util/week_from_date.dart';

void main() {
  late DateTime date;

  setUp(() {
    date = DateTime.parse('2023-03-20');
  });

  group('MonthFromDate', () {
    group('weeks', () {
      test('returns a list of length four', () {
        // arrange
        final month = MonthFromDate(date);

        // act
        final result = month.weeks;

        // assert
        expect(result, hasLength(4));
      });

      test('returns a list with the correct weeks', () {
        // arrange
        final month = MonthFromDate(date);
        final expected = List.generate(
          4,
          (index) => WeekFromDate(date.add(Duration(days: index * 7))),
        );

        // act
        final result = month.weeks;

        // assert
        expect(result, expected);
      });

      test(
          'returns a list which starts at the next week '
          'when the date is saturday', () {
        // arrange
        final date = DateTime.parse('2023-03-18');
        final month = MonthFromDate(date);

        final expectedDate = DateTime.parse('2023-03-20');
        final expected = List.generate(
          4,
          (index) => WeekFromDate(expectedDate.add(Duration(days: index * 7))),
        );

        // act
        final result = month.weeks;

        // assert
        expect(result, expected);
      });

      test(
          'returns a list which starts at the next week '
          'when the date is sunday', () {
        // arrange
        final date = DateTime.parse('2023-03-19');
        final month = MonthFromDate(date);

        final expectedDate = DateTime.parse('2023-03-20');
        final expected = List.generate(
          4,
          (index) => WeekFromDate(expectedDate.add(Duration(days: index * 7))),
        );

        // act
        final result = month.weeks;

        // assert
        expect(result, expected);
      });
    });
  });
}
