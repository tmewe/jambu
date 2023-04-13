import 'package:collection/collection.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';

class MergeHolidays {
  MergeHolidays({
    required this.presences,
    required this.holidays,
  });

  final List<Presence> presences;
  final List<Holiday> holidays;

  List<Presence> call() {
    final result = [...presences];
    for (final holiday in holidays) {
      final presence = presences.firstWhereOrNull((e) {
        return e.date.isSameDay(holiday.date);
      });
      if (presence != null && presence.isPresent) {
        result
          ..remove(presence)
          ..add(
            Presence(
              date: holiday.date,
              isPresent: false,
              reason: holiday.name,
            ),
          );
      } else {
        result.add(
          Presence(
            date: holiday.date,
            isPresent: false,
            reason: holiday.name,
          ),
        );
      }
    }
    return result;
  }
}