import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/smart_merge/merge_regular_attendances.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/extension/extension.dart';

void main() {
  group('MergeRegularAttendances', () {
    late DateTime date;

    setUp(() {
      date = DateTime.parse('2023-03-20'); // Monday
    });

    test(
        'returns empty list '
        'when regular attendances are empty '
        'and presences are empty', () {
      // arrange
      final regularAttendances = <int>[];
      final presences = <Presence>[];
      final merge = MergeRegularAttendances(
        date: date.midnight,
        regularAttendances: regularAttendances,
        presences: presences,
      );

      // act
      final result = merge();

      // assert
      expect(result, <Presence>[]);
    });

    test(
        'returns four presences at correct dates '
        'when regular attendances contain friday '
        'and presences are empty '
        'where isPresent is true', () {
      // arrange
      final regularAttendances = [5];
      final presences = <Presence>[];
      final merge = MergeRegularAttendances(
        date: date.midnight,
        regularAttendances: regularAttendances,
        presences: presences,
      );
      final expected = [
        Presence(date: DateTime.parse('2023-03-24'), isPresent: true),
        Presence(date: DateTime.parse('2023-03-31'), isPresent: true),
        Presence(date: DateTime.parse('2023-04-07'), isPresent: true),
        Presence(date: DateTime.parse('2023-04-14'), isPresent: true),
      ];

      // act
      final result = merge();

      // assert
      expect(result, expected);
    });

    test(
        'returns presences '
        'when regular attendances are empty', () {
      // arrange
      final regularAttendances = <int>[];
      final presences = [Presence(date: date, isPresent: true)];
      final merge = MergeRegularAttendances(
        date: date.midnight,
        regularAttendances: regularAttendances,
        presences: presences,
      );

      // act
      final result = merge();

      // assert
      expect(result, presences);
    });

    test(
        'returns eight presences '
        'when regular attendances contains two elements '
        'and presences are empty', () {
      // arrange
      final regularAttendances = [1, 3];
      final presences = <Presence>[];
      final merge = MergeRegularAttendances(
        date: date.midnight,
        regularAttendances: regularAttendances,
        presences: presences,
      );

      // act
      final result = merge();

      // assert
      expect(result.length, 8);
    });

    test(
        'returns four presences where the first one has isPresent is false '
        'when regular attendances contains monday '
        'and presences contains one element on monday '
        'where isPresent is false', () {
      // arrange
      final regularAttendances = [1];
      final presence = Presence(date: date, isPresent: false);
      final merge = MergeRegularAttendances(
        date: date.midnight,
        regularAttendances: regularAttendances,
        presences: [presence],
      );

      // act
      final result = merge();

      // assert
      expect(result.length, 4);
      expect(result.first, presence);
    });
  });
}
