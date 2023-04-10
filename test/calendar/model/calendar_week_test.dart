import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/model/model.dart';

void main() {
  late DateTime date;

  setUp(() {
    date = DateTime.parse('2023-04-10');
  });

  group('CalendarWeek', () {
    group('dayAtDate', () {
      test(
          'returns null '
          'when no day at date is found', () {
        // arrange
        final week = CalendarWeek(
          days: [CalendarDay(date: date, isUserAttending: false)],
        );

        // act
        final result = week.dayAtDate(date.add(const Duration(days: 3)));

        // assert
        expect(result, isNull);
      });

      test(
          'returns day '
          'when day at date is found', () {
        // arrange
        final day = CalendarDay(date: date, isUserAttending: false);
        final week = CalendarWeek(days: [day]);

        // act
        final result = week.dayAtDate(date);

        // assert
        expect(result, day);
      });
    });

    group('updateDay', () {
      test(
          'returns unchanged week '
          'when day is not in week', () {
        // arrange
        final day = CalendarDay(date: date, isUserAttending: false);
        final week = CalendarWeek(days: [day]);

        // act
        final result = week.updateDay(
          day.copyWith(date: date.add(const Duration(days: 3))),
        );

        // assert
        expect(result, week);
      });

      test(
          'returns week with updated day '
          'when day is in week', () {
        // arrange
        final day = CalendarDay(date: date, isUserAttending: false);
        final updatedDay = CalendarDay(date: date, isUserAttending: true);

        final week = CalendarWeek(days: [day]);
        final updatedWeek = CalendarWeek(days: [updatedDay]);

        // act
        final result = week.updateDay(updatedDay);

        // assert
        expect(result, updatedWeek);
      });
    });
  });

  group('CalendarWeekFromDate', () {
    test(
        'returns null '
        'when no day is at date', () {
      // arrange
      final day = CalendarDay(date: date, isUserAttending: false);
      final week = CalendarWeek(days: [day]);

      // act
      final result = [week].getWeekFromDate(date.add(const Duration(days: 3)));

      // assert
      expect(result, isNull);
    });

    test(
        'returns week '
        'for day at date', () {
      // arrange
      final day = CalendarDay(date: date, isUserAttending: false);
      final week = CalendarWeek(days: [day]);

      // act
      final result = [week].getWeekFromDate(date);

      // assert
      expect(result, week);
    });
  });

  group('UpdateWeek', () {
    test(
        'returns unchanged weeks '
        'when week is not in weeks', () {
      // arrange
      final day = CalendarDay(date: date, isUserAttending: false);
      final week = CalendarWeek(days: [day]);

      final updatedDay = CalendarDay(
        date: date.add(const Duration(days: 7)),
        isUserAttending: false,
      );
      final updatedWeek = CalendarWeek(days: [updatedDay]);

      // act
      final result = [week].updateWeek(updatedWeek);

      // assert
      expect(result, [week]);
    });

    test(
        'returns weeks with updated week '
        'when week is in weeks', () {
      // arrange
      final day = CalendarDay(date: date, isUserAttending: false);
      final week = CalendarWeek(days: [day]);

      final updatedDay = CalendarDay(date: date, isUserAttending: true);
      final updatedWeek = CalendarWeek(days: [updatedDay]);

      // act
      final result = [week].updateWeek(updatedWeek);

      // assert
      expect(result, [updatedWeek]);
    });
  });

  group('UpdateDay', () {
    test(
        'returns unchanged weeks '
        'when day is not in weeks', () {
      // arrange
      final day = CalendarDay(date: date, isUserAttending: false);
      final week = CalendarWeek(days: [day]);

      final updatedDay = CalendarDay(
        date: date.add(const Duration(days: 7)),
        isUserAttending: false,
      );
      final updatedWeek = CalendarWeek(days: [updatedDay]);

      // act
      final result = [week].updateWeek(updatedWeek);

      // assert
      expect(result, [week]);
    });

    test(
        'returns weeks with updated day '
        'when week is in weeks', () {
      // arrange
      final day = CalendarDay(date: date, isUserAttending: false);
      final week = CalendarWeek(days: [day]);

      final updatedDay = CalendarDay(date: date, isUserAttending: true);
      final updatedWeek = CalendarWeek(days: [updatedDay]);

      // act
      final result = [week].updateWeek(updatedWeek);

      // assert
      expect(result, [updatedWeek]);
    });
  });

  group('DayAtDate', () {
    test(
        'returns null '
        'when no day at date is found', () {
      // arrange
      final week = CalendarWeek(
        days: [CalendarDay(date: date, isUserAttending: false)],
      );

      // act
      final result = [week].dayAtDate(date.add(const Duration(days: 3)));

      // assert
      expect(result, isNull);
    });

    test(
        'returns day '
        'when day at date is found', () {
      // arrange
      final day = CalendarDay(date: date, isUserAttending: false);
      final week = CalendarWeek(days: [day]);

      // act
      final result = [week].dayAtDate(date);

      // assert
      expect(result, day);
    });
  });

  group('FindUser', () {
    test(
        'returns null '
        'when no day contains the user', () {
      // arrange
      final week = CalendarWeek(
        days: [CalendarDay(date: date, isUserAttending: false)],
      );

      // act
      final result = [week].firstUserOrNull('0');

      // assert
      expect(result, isNull);
    });

    test(
        'returns user '
        'when min one day contains the user', () {
      // arrange
      const user = CalendarUser(id: '0', name: 'Test User');
      final day = CalendarDay(
        date: date,
        isUserAttending: false,
        users: const [user],
      );
      final week = CalendarWeek(days: [day]);

      // act
      final result = [week].firstUserOrNull('0');

      // assert
      expect(result, user);
    });
  });
}
