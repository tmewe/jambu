import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/extension/extension.dart';

void main() {
  group('CalendarName', () {
    test('returns string with (jambu) at the end', () {
      // arrange
      const input = 'Favorites';

      // act
      final result = input.calendarName;

      // assert
      expect(result, '$input (jambu)');
    });
  });
}
