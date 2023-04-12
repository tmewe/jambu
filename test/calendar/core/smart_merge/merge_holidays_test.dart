import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/smart_merge/merge_holidays.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/model/model.dart';

void main() {
  group('MergeHolidays', () {
    test(
        'returns presences '
        'when holidays are empty', () {
      // arrange
      final presences = [
        Presence(date: DateTime.parse('2023-04-10'), isPresent: true),
      ];
      final merge = MergeHolidays(
        presences: presences,
        holidays: [],
      );

      // act
      final result = merge();

      // assert
      expect(result, presences);
    });

    test(
        'returns one element where isPresent is false and has reason '
        'when holidays and presences contain the same date', () {
      // arrange
      final date = DateTime.parse('2023-04-10');

      const holidayName = 'Ostermontag';
      final holidays = [
        Holiday(name: holidayName, date: date, nationwide: true),
      ];
      final presences = [Presence(date: date, isPresent: true)];
      final merge = MergeHolidays(
        presences: presences,
        holidays: holidays,
      );

      // act
      final result = merge();

      // assert
      expect(
        result,
        [Presence(date: date, isPresent: false, reason: holidayName)],
      );
    });

    test(
        'returns presences '
        'when absences and presences have no matching date', () {
      // arrange
      final firstDate = DateTime.parse('2023-04-10');
      final secondDate = DateTime.parse('2023-04-11');

      const holidayName = 'Ostermontag';
      final holidays = [
        Holiday(name: holidayName, date: firstDate, nationwide: true),
      ];
      final presences = [
        Presence(date: secondDate, isPresent: true),
      ];
      final merge = MergeHolidays(
        presences: presences,
        holidays: holidays,
      );

      final expected = [
        Presence(date: secondDate, isPresent: true),
        Presence(date: firstDate, isPresent: false, reason: holidayName),
      ];

      // act
      final result = merge();

      // assert
      expect(result, expected);
    });
  });
}
