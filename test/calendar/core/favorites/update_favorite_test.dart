import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/favorites/update_favorite.dart';
import 'package:jambu/calendar/model/model.dart';

void main() {
  group('UpdateFavorite', () {
    late CalendarUser user;
    late DateTime date;
    late List<CalendarWeek> weeks;

    setUp(() {
      user = const CalendarUser(id: '0', name: 'Test');
      date = DateTime.parse('2023-04-10');
    });
    group('Add favorite', () {
      const isFavorite = true;

      setUp(() {
        weeks = [
          CalendarWeek(
            days: [
              CalendarDay(date: date, isUserAttending: false, users: [user]),
            ],
          ),
        ];
      });

      test(
          'Calendar weeks contain user where isFavorite is true '
          'when weeks contain user where isFavorite is false ', () {
        // arrange
        final update = UpdateFavorite(
          userId: user.id,
          isFavorite: isFavorite,
          weeks: weeks,
        );

        final expectedResult = [
          CalendarWeek(
            days: [
              CalendarDay(
                date: date,
                isUserAttending: false,
                users: [user.copyWith(isFavorite: true)],
              ),
            ],
          ),
        ];

        // act
        final result = update();

        // assert
        expect(result, expectedResult);
      });
    });

    group('Remove favorite', () {
      const isFavorite = false;

      setUp(() {
        user = user.copyWith(isFavorite: true);
        weeks = [
          CalendarWeek(
            days: [
              CalendarDay(date: date, isUserAttending: false, users: [user]),
            ],
          ),
        ];
      });

      test(
          'Calendar weeks contain user where isFavorite is false '
          'when weeks contain user where isFavorite is true ', () {
        // arrange
        final update = UpdateFavorite(
          userId: user.id,
          isFavorite: isFavorite,
          weeks: weeks,
        );

        final expectedResult = [
          CalendarWeek(
            days: [
              CalendarDay(
                date: date,
                isUserAttending: false,
                users: [user.copyWith(isFavorite: false)],
              ),
            ],
          ),
        ];

        // act
        final result = update();

        // assert
        expect(result, expectedResult);
      });
    });
  });
}
