import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/smart_merge/merge_manual_absences.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';

void main() {
  group('MergeManualAbsences', () {
    test(
        'returns presences '
        'when absences are empty', () {
      // arrange
      final absences = <DateTime>[];
      final presences = [
        Presence(date: DateTime.parse('2023-03-20'), isPresent: true),
      ];
      final merge = MergeManualAbsences(
        presences: presences,
        absences: absences,
      );

      // act
      final result = merge();

      // assert
      expect(result, presences);
    });

    test(
        'returns one element where isPresent is false '
        'when absences and presences contain the same date', () {
      // arrange
      final date = DateTime.parse('2023-03-20');
      final presences = [Presence(date: date, isPresent: true)];
      final merge = MergeManualAbsences(
        presences: presences,
        absences: [date],
      );

      // act
      final result = merge();

      // assert
      expect(result, [Presence(date: date, isPresent: false)]);
    });

    test(
        'returns presences '
        'when absences and presences have no matching date', () {
      // arrange
      final firstDate = DateTime.parse('2023-03-21');
      final secondDate = DateTime.parse('2023-03-22');
      final absences = [firstDate];
      final presences = [
        Presence(date: secondDate, isPresent: true),
      ];
      final merge = MergeManualAbsences(
        presences: presences,
        absences: absences,
      );

      final expected = [
        Presence(date: secondDate, isPresent: true),
        Presence(date: firstDate, isPresent: false),
      ];

      // act
      final result = merge();

      // assert
      expect(result, expected);
    });
  });
}
