import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/util/util.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';

class CalendarMapping {
  CalendarMapping({
    required this.currentUser,
    required this.attendances,
    required this.users,
  });

  final User currentUser;
  final List<Attendance> attendances;
  final List<User> users;

  List<CalendarWeek> call() {
    final currentMonth = MonthFromDate(DateTime.now().midnight);

    final weeks = <CalendarWeek>[];
    for (final week in currentMonth.weeks) {
      final days = <CalendarDay>[];

      for (final date in week.workingDays) {
        final attendanceAtDate = attendances.getAtDate(date);

        final isUserAttending =
            attendanceAtDate.userIds.contains(currentUser.id);
        final usersAtDay = attendanceAtDate.userIds.where((uid) {
          return uid != currentUser.id;
        }).map((uid) {
          final filteredUsers = users.where((u) => u.id == uid);
          if (filteredUsers.isEmpty) {
            return CalendarUser(id: uid, name: '-');
          }
          final user = filteredUsers.first;
          return CalendarUser(id: uid, name: user.name);
        });

        final day = CalendarDay(
          date: date,
          isUserAttending: isUserAttending,
          users: usersAtDay.toList(),
        );
        days.add(day);
      }
      weeks.add(CalendarWeek(days: days));
    }
    return weeks;
  }
}
