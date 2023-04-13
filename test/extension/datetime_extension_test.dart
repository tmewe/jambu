import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/extension/extension.dart';

void main() {
  group('DayString', () {
    group('weekdayString', () {
      test('returns correct strings', () {
        // arrange
        final dates = List.generate(6, (i) => i).map(
          (i) => DateTime.parse('2023-04-10').add(Duration(days: i)),
        );
        final expectedResult = [
          'Montag',
          'Dienstag',
          'Mittwoch',
          'Donnerstag',
          'Freitag',
          '-'
        ];

        // act
        final results = dates.map((d) => d.weekdayString);

        // assert
        expect(results, expectedResult);
      });
    });

    group('weekdayStringShort', () {
      test('returns correct strings', () {
        // arrange
        final dates = List.generate(6, (i) => i).map(
          (i) => DateTime.parse('2023-04-10').add(Duration(days: i)),
        );
        final expectedResult = ['Mo', 'Di', 'Mi', 'Do', 'Fr', '-'];

        // act
        final results = dates.map((d) => d.weekdayStringShort);

        // assert
        expect(results, expectedResult);
      });
    });
  });

  group('Midnight', () {
    test(
        'returns date at midnight '
        'when date contains date and time', () {
      // arrange
      final date = DateTime.parse('2023-04-10 13:27:00');
      final expectedDate = DateTime.parse('2023-04-10');

      // act
      final result = date.midnight;

      // assert
      expect(result, expectedDate);
    });
  });

  group('FirstDateOfWeek', () {
    test('returns first date of week', () {
      // arrange
      final startDate = DateTime.parse('2023-04-10'); // Monday
      final dates = List.generate(7, (i) => startDate.add(Duration(days: i)));
      // act
      final result = dates.map((d) => d.firstDateOfWeek);

      // assert
      expect(result, List.generate(7, (_) => startDate));
    });
  });

  group('IsSameDay', () {
    test(
        'returns true '
        'when dates are at same day', () {
      // arrange
      final left = DateTime.parse('2023-04-10');
      final right = DateTime.parse('2023-04-11');

      // act
      final result = right.isSameDay(left);

      // assert
      expect(result, isFalse);
    });

    test(
        'returns false '
        'when dates are not same day', () {
      // arrange
      final left = DateTime.parse('2023-04-10');
      final right = DateTime.parse('2023-04-10');

      // act
      final result = right.isSameDay(left);

      // assert
      expect(result, isTrue);
    });
  });
}
