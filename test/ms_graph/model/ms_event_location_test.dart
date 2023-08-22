import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/ms_graph/model/model.dart';

void main() {
  group('MSEventLocation', () {
    group('isInMeetingRoom', () {
      test('returns false when display name is empty', () {
        // arrange
        final location = MSEventLocation(displayName: '');

        // act
        final result = location.isInMeetingRoom;

        // assert
        expect(result, isFalse);
      });

      test('returns true when meeting romms contains display name', () {
        // act
        for (final room in Constants.allMeetingRooms) {
          final location = MSEventLocation(displayName: room);
          final result = location.isInMeetingRoom;
          // assert
          expect(result, isTrue);
        }
      });
    });
  });
}
