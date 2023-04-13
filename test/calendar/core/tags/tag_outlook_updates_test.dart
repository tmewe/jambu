import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

void main() {
  group('TagOutlookUpdates', () {
    late String tagName;
    late DateTime date;
    late CalendarUser user;

    setUp(() {
      tagName = 'Masterarbeit';
      date = DateTime.parse('2023-04-10');
      user = CalendarUser(id: '0', name: 'Test', tags: [tagName]);
    });

    group('eventsToAdd', () {
      test(
          'is empty '
          'when no user is attending', () {
        // arrange
        final week = CalendarWeek(
          days: [CalendarDay(date: date, isUserAttending: false)],
        );

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, isEmpty);
      });

      test(
          'is empty '
          'when no user has the given tag', () {
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

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, isEmpty);
      });

      test(
          'is empty '
          'when one user has the given tag '
          'and is attending on one day '
          'and event for this user and tag is existing', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(date: date, isUserAttending: false, users: [user]),
          ],
        );

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [MSEvent.fromUser(date: date, userName: user.name)],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToAdd, isEmpty);
      });

      test(
          'contains one event '
          'when one user has the given tag '
          'and is attending on one day', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(date: date, isUserAttending: false, users: [user])
          ],
        );

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [],
        );

        // act
        final result = updates();

        // assert
        final event = result.eventsToAdd.first;
        expect(result.eventsToAdd, hasLength(1));
        expect(
          event,
          MSEvent.fromUser(date: event.start.date, userName: event.subject),
        );
      });

      test(
          'contains two events '
          'when one user has the given tag '
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

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [],
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
          'when two users have the given tag '
          'and are attending on one day each', () {
        // arrange
        final user1 = CalendarUser(id: '1', name: 'Test', tags: [tagName]);
        final week = CalendarWeek(
          days: [
            CalendarDay(date: date, isUserAttending: false, users: [user]),
            CalendarDay(
              date: date.add(const Duration(days: 1)),
              isUserAttending: false,
              users: [user1],
            ),
          ],
        );

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [],
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
          'when no user is attending '
          'and events for tag is empty', () {
        // arrange
        final week = CalendarWeek(
          days: [CalendarDay(date: date, isUserAttending: false)],
        );

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, isEmpty);
      });

      test(
          'is empty '
          'when events for tag is empty', () {
        // arrange
        final week = CalendarWeek(
          days: [CalendarDay(date: date, isUserAttending: false)],
        );

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, isEmpty);
      });

      test(
          'contains one event '
          'when events for tag contains one event '
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

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [
            MSEvent.fromUser(date: date, userName: user.name),
          ],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, hasLength(1));
      });

      test(
          'contains one event '
          'when events for tag contains one event '
          'and user does not have the tag', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(
              date: date,
              isUserAttending: false,
              users: [user.copyWith(tags: [])],
            ),
          ],
        );

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [
            MSEvent.fromUser(date: date, userName: user.name),
          ],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, hasLength(1));
      });

      test('contains duplicate events', () {
        // arrange
        final week = CalendarWeek(
          days: [
            CalendarDay(
              date: date,
              isUserAttending: false,
              users: [user],
            ),
          ],
        );

        final duplicateEvent = MSEvent.fromUser(
          date: date,
          userName: user.name,
        );

        final updates = TagOutlookUpdates(
          tagName: tagName,
          attendances: [week],
          eventsForTag: [duplicateEvent, duplicateEvent],
        );

        // act
        final result = updates();

        // assert
        expect(result.eventsToRemove, [duplicateEvent]);
      });
    });
  });
}
