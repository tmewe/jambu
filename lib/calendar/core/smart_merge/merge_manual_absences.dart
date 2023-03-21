import 'package:collection/collection.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/extension/extension.dart';

class MergeManualAbsences {
  MergeManualAbsences({
    required this.presences,
    required this.absences,
  });

  final List<Presence> presences;
  final List<DateTime> absences;

  List<Presence> call() {
    final result = [...presences];
    for (final date in absences) {
      final presence = presences.firstWhereOrNull((e) {
        return e.date.isSameDay(date);
      });
      if (presence != null && presence.isPresent) {
        result
          ..remove(presence)
          ..add(Presence(date: date, isPresent: false));
      } else {
        result.add(Presence(date: date, isPresent: false));
      }
    }
    return result;
  }
}
