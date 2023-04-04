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
        final presentEntry = attendance.present.firstWhereOrNull(
          (e) => e.userId == currentUser.id,
        );
        final absentEntry = attendance.absent.firstWhereOrNull(
          (e) => e.userId == currentUser.id,
        );
        final isUserAttending = presentEntry != null && absentEntry == null;
        final reason = presentEntry?.reason ?? absentEntry?.reason;
        final day = CalendarDay(
          date: date,
          isUserAttending: isUserAttending,
          users: _colleaguesAtDay(attendance),
          reason: reason,
        );
        days.add(day);
      }
      weeks.add(CalendarWeek(days: days));
    }
    return weeks;
  }

  // Filters and maps the user ids at date to calendar users
  List<CalendarUser> _colleaguesAtDay(Attendance attendance) {
    return attendance.present
        .where((uid) => uid.userId != currentUser.id)
        .map((uid) => users.firstWhereOrNull((u) => u.id == uid.userId))
        .whereNotNull()
        .map(
          (colleague) => CalendarUser(
            id: colleague.id,
            name: colleague.name,
            jobTitle: colleague.jobTitle,
            image: colleague.imageUrl,
            tags: currentUser.tags
                .where((tag) => tag.userIds.contains(colleague.id))
                .map((t) => t.name)
                .toList(),
            isFavorite: currentUser.favorites.contains(colleague.id),
          ),
        )
        .toList();
  }
}
