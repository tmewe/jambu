import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/favorites/favorites.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

void main() {
  group('FavoritesOutlookUpdates', () {
    late DateTime date;
    late CalendarUser user;

    setUp(() {
      date = DateTime.parse('2023-04-10');
      user = const CalendarUser(id: '0', name: 'Test');
    });
    group('eventsToAdd', () {
      test(
          'is empty '
          'when user has no favorites', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(date: date, isUserAttending: true, users: [user])
          ],
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: [],
          attendances: [week],
          favoriteEvents: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, isEmpty);
      });

      test(
          'is empty '
          'when favorite events match user attendances', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(
              date: date,
              isUserAttending: false,
              users: const [CalendarUser(id: '0', name: 'Test')],
            )
          ],
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: ['0'],
          attendances: [week],
          favoriteEvents: [MSEvent.fromUser(date: date, userName: user.name)],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, isEmpty);
      });

      test(
          'is empty '
          'when no users are attending', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(
              date: date,
              isUserAttending: false,
            )
          ],
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: ['0'],
          attendances: [week],
          favoriteEvents: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, isEmpty);
      });

      test(
          'contains two events '
          'when one user is favorite '
          'and is attending on two days', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(date: date, isUserAttending: false, users: [user]),
            CalendarDay(
              date: date.add(const Duration(days: 1)),
              isUserAttending: false,
              users: [user],
            ),
          ],
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: ['0'],
          attendances: [week],
          favoriteEvents: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, hasLength(2));
        for (final event in result.eventsToAdd) {
          expect(
            event,
            MSEvent.fromUser(date: event.start.date, userName: event.subject),
          );
        }
      });

      test(
          'contains two events '
          'when two users are favorites '
          'and are attending on one day each', () {
        // arrange
        const user1 = CalendarUser(id: '1', name: 'Test');
        final week = CalendarWeek(
          days: [
            CalendarDay(date: date, isUserAttending: false, users: [user]),
            CalendarDay(
              date: date.add(const Duration(days: 1)),
              isUserAttending: false,
              users: const [user1],
            ),
          ],
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: ['0', '1'],
          attendances: [week],
          favoriteEvents: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, hasLength(2));
        for (final event in result.eventsToAdd) {
          expect(
            event,
            MSEvent.fromUser(date: event.start.date, userName: event.subject),
          );
        }
      });
    });

    group('eventsToRemove', () {
      test(
          'is empty '
          'when favorite events is empty', () {
        // arrange
        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: [],
          attendances: [],
          favoriteEvents: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, isEmpty);
      });

      test(
          'is empty '
          'when favorite events match user attendances', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(
              date: date,
              isUserAttending: false,
              users: const [CalendarUser(id: '0', name: 'Test')],
            )
          ],
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: ['0'],
          attendances: [week],
          favoriteEvents: [MSEvent.fromUser(date: date, userName: user.name)],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, isEmpty);
      });

      test(
          'contains one event '
          'when favorite events contains one event '
          'and user is not attending at this date', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(
              date: date.add(const Duration(days: 1)),
              isUserAttending: false,
              users: [user],
            ),
          ],
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: ['0'],
          attendances: [week],
          favoriteEvents: [MSEvent.fromUser(date: date, userName: user.name)],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, hasLength(1));
      });

      test(
          'contains one event '
          'when favorite events contains one event '
          'and user is not a favorite', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(
              date: date.add(const Duration(days: 1)),
              isUserAttending: false,
              users: [user],
            ),
          ],
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: [],
          attendances: [week],
          favoriteEvents: [MSEvent.fromUser(date: date, userName: user.name)],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, hasLength(1));
      });

      test('contains duplicate events', () {
        // arrange
        const anotherUser = CalendarUser(id: '1', name: 'Another');
        final week = CalendarWeek(
          days: [
            CalendarDay(
              date: date,
              isUserAttending: true,
              users: [user, anotherUser],
            ),
          ],
        );

        final duplicateEventUser = MSEvent.fromUser(
          date: date,
          userName: user.name,
        );

        final duplicateEventAnotherUser = MSEvent.fromUser(
          date: date,
          userName: anotherUser.name,
        );

        final updates = FavoritesOutlookUpdates(
          favoriteUserIds: [user.id, anotherUser.id],
          attendances: [week],
          favoriteEvents: [
            duplicateEventUser,
            duplicateEventUser,
            duplicateEventUser,
            duplicateEventAnotherUser,
            duplicateEventAnotherUser,
          ],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, [
          duplicateEventUser,
          duplicateEventUser,
          duplicateEventAnotherUser,
        ]);
      });
    });
  });
}
