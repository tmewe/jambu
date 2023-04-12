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
    required List<String> favoriteUserIds,
    required List<CalendarWeek> attendances,
    required List<MSEvent> favoriteEvents,
  })  : _favoriteUserIds = favoriteUserIds,
        _attendances = attendances,
        _favoriteEvents = favoriteEvents;

  final List<String> _favoriteUserIds;
  final List<CalendarWeek> _attendances;
  final List<MSEvent> _favoriteEvents;

  FavoriteEventsUpdates call() {
    //  Map users with given user id to events
    final updatedEvents = _attendances
        .map((a) => a.days)
        .expand((e) => e)
        .map((day) {
          return day.users
              .where((user) => _favoriteUserIds.contains(user.id))
              .map(
                (user) => MSEvent.fromUser(
                  date: day.date,
                  userName: user.name,
                ),
              );
        })
        .expand((e) => e)
        .toList();

    final uniqueFavoriteEvents = _favoriteEvents.toSet();
    final uniqueUpdatedEvents = updatedEvents.toSet();

    final duplicateEvents = [..._favoriteEvents];
    for (final unique in uniqueFavoriteEvents) {
      if (duplicateEvents.contains(unique)) duplicateEvents.remove(unique);
    }

    final eventsToAdd =
        uniqueUpdatedEvents.difference(uniqueFavoriteEvents).toList();

    final eventsToRemove =
        uniqueFavoriteEvents.difference(uniqueUpdatedEvents).toList();

    return FavoriteEventsUpdates(
      eventsToAdd: eventsToAdd,
      eventsToRemove: [...eventsToRemove, ...duplicateEvents],
    );
  }
}
