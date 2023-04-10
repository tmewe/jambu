import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/model/model.dart';

void main() {
  late DateTime date;

  setUp(() {
    date = DateTime.parse('2023-04-10');
  });

  group('CalendarDay', () {
    group('copyWithoutReason', () {
      test(
          'reason is null '
          'when no reason is supplied '
          'and other fields stay the same', () {
        // arrange
        final day = CalendarDay(
          date: date,
          isUserAttending: false,
          reason: 'Urlaub',
        );

        // act
        final updatedDay = day.copyWithoutReason();

        // assert
        expect(updatedDay.date, day.date);
        expect(updatedDay.isUserAttending, day.isUserAttending);
        expect(updatedDay.users, day.users);
        expect(updatedDay.reason, isNull);
      });

      test(
          'reason is not null '
          'when reason is supplied '
          'and other fields stay the same', () {
        // arrange
        const reason = 'Urlaub';
        final day = CalendarDay(
          date: date,
          isUserAttending: false,
        );

        // act
        final updatedDay = day.copyWithoutReason(reason: reason);

        // assert
        expect(updatedDay.date, day.date);
        expect(updatedDay.isUserAttending, day.isUserAttending);
        expect(updatedDay.users, day.users);
        expect(updatedDay.reason, reason);
      });
    });
  });
}
