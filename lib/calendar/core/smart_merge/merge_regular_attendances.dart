import 'package:collection/collection.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/calendar/util/month_from_date.dart';
import 'package:jambu/extension/extension.dart';

class MergeRegularAttendances {
  MergeRegularAttendances({
    required this.date,
    required this.regularAttendances,
    required this.presences,
  });

  final DateTime date;
  final List<int> regularAttendances;
  final List<Presence> presences;

  List<Presence> call() {
    if (regularAttendances.isEmpty) {
      return presences;
    }

    final resultPresences = [...presences];
    final currentMonth = MonthFromDate(date.midnight);
    for (final week in currentMonth.weeks) {
      for (final date in week.workingDays) {
        if (regularAttendances.contains(date.weekday)) {
          final presenceAtDate = presences.firstWhereOrNull((e) {
            return e.date.isSameDay(date);
          });
          // Only add a presence if none exists
          // If there already is a presence where isPresent == false
          // we don't want to change it because of an oof ms event
          if (presenceAtDate == null) {
            resultPresences.add(
              Presence(
                date: date.midnight,
                isPresent: true,
              ),
            );
          }
        }
      }
    }

    return resultPresences;
  }
}
