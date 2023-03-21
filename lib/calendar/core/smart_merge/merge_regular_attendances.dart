import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/calendar/util/month.dart';
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
          final presenceAtDate = presences.indexWhere((e) {
            return e.date.isSameDay(date);
          });
          if (presenceAtDate == -1) {
            resultPresences.add(
              Presence(date: date.midnight, isPresent: true),
            );
          }
        }
      }
    }

    return resultPresences;
  }
}
