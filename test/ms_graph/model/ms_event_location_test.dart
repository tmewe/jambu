import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/ms_graph/model/model.dart';

void main() {
  group('MSEventLocation', () {
    group('isURL', () {
      test('returns true when url is valid', () {
        // arrange
        final location = MSEventLocation(
          displayName: 'live.jambit.com',
          locationType: 'default',
        );

        // act
        final result = location.isURL;

        // assert
        expect(result, isTrue);
      });

      test('returns false when url is not valid', () {
        // arrange
        final location = MSEventLocation(
          displayName: 'Raumbuchung für Sprintwechsel',
          locationType: 'conferenceRoom',
        );

        // act
        final result = location.isURL;

        // assert
        expect(result, isFalse);
      });
    });
  });
}
