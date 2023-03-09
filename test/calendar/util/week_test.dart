import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/util/util.dart';

void main() {
  void testCorrectDates(DateTime input, List<DateTime> dates) {
    // arrange
    final sut = Week(date: input);

    // act
    final result = sut.workingDays;

    // assert
    expect(result, dates);
  }

  group('workingDays', () {
    test('Returs an array containing five elements', () {
      // arrange
      final sut = Week(date: DateTime.now());

      // act
      final result = sut.workingDays;

      // assert
      expect(result.length, 5);
    });

    group('Returns correct dates', () {
      final monday = DateTime.parse('2023-03-06');
      final tuesday = DateTime.parse('2023-03-07');
      final wednesday = DateTime.parse('2023-03-08');
      final thursday = DateTime.parse('2023-03-09');
      final friday = DateTime.parse('2023-03-10');

      final dates = [monday, tuesday, wednesday, thursday, friday];

      test('Returns correct dates if input is monday', () {
        testCorrectDates(monday, dates);
      });

      test('Returns correct dates if input is tuesday', () {
        testCorrectDates(tuesday, dates);
      });

      test('Returns correct dates if input is wednesday', () {
        testCorrectDates(wednesday, dates);
      });

      test('Returns correct dates if input is thursday', () {
        testCorrectDates(thursday, dates);
      });

      test('Returns correct dates if input is friday', () {
        testCorrectDates(friday, dates);
      });
    });
  });
}
