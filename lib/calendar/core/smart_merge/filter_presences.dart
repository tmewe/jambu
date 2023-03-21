import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/extension/extension.dart';

class FilterPresences {
  FilterPresences({
    required this.presences,
  });

  List<Presence> presences;

  List<Presence> call() {
    final uniqueDays = <Presence>[];
    for (final presence in presences) {
      final index = uniqueDays.indexWhere((e) {
        return e.date.isSameDay(presence.date);
      });

      if (index == -1) {
        uniqueDays.add(presence);
      } else {
        final existingStatus = uniqueDays[index];
        if (existingStatus.isPresent == true && presence.isPresent == false) {
          uniqueDays
            ..removeAt(index)
            ..add(presence);
        }
      }
    }
    return uniqueDays;
  }
}
