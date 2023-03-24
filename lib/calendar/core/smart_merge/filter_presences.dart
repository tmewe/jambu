import 'package:collection/collection.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/extension/extension.dart';

/// Makes sure only one presence per day exists
/// If there are multiple it takes the presence where `isPresent == false`
class FilterPresences {
  FilterPresences({
    required this.presences,
  });

  List<Presence> presences;

  List<Presence> call() {
    final uniqueDays = <Presence>[];
    for (final presence in presences) {
      final day = uniqueDays.firstWhereOrNull((e) {
        return e.date.isSameDay(presence.date);
      });

      if (day == null) {
        uniqueDays.add(presence);
      } else {
        if (day.isPresent == true && presence.isPresent == false) {
          uniqueDays
            ..remove(day)
            ..add(presence);
        }
      }
    }
    return uniqueDays;
  }
}
