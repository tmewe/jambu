import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/extension/extension.dart';

void main() {
  group('MaxValues', () {
    test(
        'returns empty list '
        'when values max is 0', () {
      // arrange
      const map = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      // act
      final result = map.maxValues;

      // assert
      expect(result, isEmpty);
    });

    test(
        'returns list with one item '
        'when values has one max value', () {
      // arrange
      const maxDay = 3;
      const map = {0: 3, 1: 2, 2: 5, maxDay: 10, 4: 3, 5: 1};

      // act
      final result = map.maxValues;

      // assert
      expect(result, [maxDay]);
    });

    test(
        'returns list with three items '
        'when values have three values with the same max', () {
      // arrange
      const maxDay1 = 1;
      const maxDay3 = 3;
      const maxDay4 = 4;
      const map = {maxDay1: 10, 2: 2, maxDay3: 10, maxDay4: 10, 5: 1};

      // act
      final result = map.maxValues;

      // assert
      expect(result, [maxDay1, maxDay3, maxDay4]);
    });
  });
}
