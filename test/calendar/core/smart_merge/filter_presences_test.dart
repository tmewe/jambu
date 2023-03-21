import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/smart_merge/filter_presences.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';

void main() {
  group('FilterPresences', () {
    late DateTime date;

    setUp(() {
      date = DateTime.parse('2023-03-20');
    });

    test(
        'returns input list '
        'when there is only one presence per day', () {
      // arrange
      final presences = [
        Presence(date: date, isPresent: true),
        Presence(date: date.add(const Duration(days: 1)), isPresent: false),
        Presence(date: date.add(const Duration(days: 2)), isPresent: false),
        Presence(date: date.add(const Duration(days: 3)), isPresent: true),
      ];
      final filter = FilterPresences(presences: presences);

      // act
      final result = filter();

      // assert
      expect(result, presences);
    });

    test(
        'removes presences where isPresent is true '
        'when there is antoher presence on same day where isPresent is false',
        () {
      // arrange
      final presences = [
        Presence(date: date, isPresent: true),
        Presence(date: date.add(const Duration(days: 1)), isPresent: true),
        Presence(date: date.add(const Duration(days: 1)), isPresent: false),
        Presence(date: date.add(const Duration(days: 1)), isPresent: true),
      ];

      final expected = [
        Presence(date: date, isPresent: true),
        Presence(date: date.add(const Duration(days: 1)), isPresent: false),
      ];

      final filter = FilterPresences(presences: presences);

      // act
      final result = filter();

      // assert
      expect(result, expected);
    });
  });
}
