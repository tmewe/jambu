import 'package:collection/collection.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/util/util.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';

class CalendarMapping {
  const CalendarMapping({
    required this.currentUser,
    required this.attendances,
    required this.users,
    this.today,
  });

  final User currentUser;
  final List<Attendance> attendances;
  final List<User> users;
  final DateTime? today;

  List<CalendarWeek> call() {
    final currentMonth = MonthFromDate(
      today?.midnight ?? DateTime.now().midnight,
    );

    final weeks = <CalendarWeek>[];
    for (final week in currentMonth.weeks) {
      final days = <CalendarDay>[];

      for (final date in week.workingDays) {
        final attendance = attendances.getAtDate(date);

        // Filters and maps the user ids at date to calendar users
        final colleaguesAtDay = attendance.userIds
            .where((uid) => uid != currentUser.id)
            .map((uid) => users.firstWhereOrNull((u) => u.id == uid))
            .whereNotNull()
            .map(
              (colleague) => CalendarUser(
                id: colleague.id,
                name: colleague.name,
                jobTitle: colleague.jobTitle,
                image: colleague.imageUrl,
              ),
            );

        final isUserAttending = attendance.userIds.contains(currentUser.id);
        final day = CalendarDay(
          date: date,
          isUserAttending: isUserAttending,
          users: colleaguesAtDay.toList(),
        );
        days.add(day);
      }
      weeks.add(CalendarWeek(days: days));
    }
    return weeks;
  }
}
