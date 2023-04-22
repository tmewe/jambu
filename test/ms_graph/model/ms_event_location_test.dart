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
        // arrange
        final rooms = [
          'Raum 4.01 Arabica',
          'Raum 4.09 Djampit',
          'Raum 4.25 Kona',
          'Raum 4.43 Liberica',
          'Raum 4.61 Robusta',
          'Raum 4.65 Tupi | Gamingraum',
          'Raum 5.01 Americano',
          'Raum 5.11 Cappuccino',
          'Raum 5.25 Espresso',
          'Raum Frappé',
          'Raum 5.39 Latte',
          'Raum 5.51 Lungo',
          'Raum 5.61 Ristretto',
          'Raum 6.01 Bali',
          'Raum 6.03 Biang',
          'Raum 6.11 Lombok',
          'Raum 6.13 Sumatra',
          'Raum 6.57 Toko',
          'Raum 13.1 Dempo',
          'Raum 13.2 Gama-Lama',
          'Raum 13.3 Kerinchi',
          'Raum 13.4 Lokon',
          'Raum 13.5 Merbabu',
          'Raum 13.6 Mutis',
          'Raum 13.7 Sundoro',
          'Raum 13.8 Tambora',
          'Raum Medan Leipzig 3.OG',
          'Raum Jakarta Leipzig 3.OG',
          'Raum Bandung Leipzig 2.OG',
          'Raum Nobo Leipzig 1.OG',
          'Raum Kelimutu Stuttgart',
          'Raum Alapolo Stuttgart',
          'Raum Gado-gado Erfurt'
        ];

        // act
        for (final room in rooms) {
          final location = MSEventLocation(displayName: room);
          final result = location.isInMeetingRoom;
          // assert
          expect(result, isTrue);
        }
      });
    });
  });
}
