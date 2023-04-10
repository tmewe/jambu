import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

class FavoriteEventsUpdates {
  FavoriteEventsUpdates({
    required this.eventsToAdd,
    required this.eventsToRemove,
  });

  final List<MSEvent> eventsToAdd;
  final List<MSEvent> eventsToRemove;
}

class FavoritesOutlookUpdates {
  FavoritesOutlookUpdates({
    required List<String> userIds,
    required List<CalendarWeek> attendances,
    required List<MSEvent> eventsForUserId,
  })  : _userIds = userIds,
        _attendances = attendances,
        _events = eventsForUserId;

  final List<String> _userIds;
  final List<CalendarWeek> _attendances;
  final List<MSEvent> _events;

  FavoriteEventsUpdates call() {
    //  Map users with given user id to events
    final updatedEvents = _attendances
        .map((a) => a.days)
        .expand((e) => e)
        .map((day) {
          return day.users.where((user) => _userIds.contains(user.id)).map(
                (user) => MSEvent.fromUser(
                  date: day.date,
                  userName: user.name,
                ),
              );
        })
        .expand((e) => e)
        .toList();

    final eventsToAdd =
        updatedEvents.toSet().difference(_events.toSet()).toList();

    final eventsToRemove =
        _events.toSet().difference(updatedEvents.toSet()).toList();

    return FavoriteEventsUpdates(
      eventsToAdd: eventsToAdd,
      eventsToRemove: eventsToRemove,
    );
  }
}
