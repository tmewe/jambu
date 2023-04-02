import 'package:jambu/calendar/model/model.dart';

class UpdateTagName {
  const UpdateTagName({
    required this.tagName,
    required this.newTagName,
    required this.weeks,
  });

  final String tagName;
  final String newTagName;
  final List<CalendarWeek> weeks;

  List<CalendarWeek> call() {
    final updatedWeeks = <CalendarWeek>[];
    for (final week in weeks) {
      final updatedDays = <CalendarDay>[];
      for (final day in week.days) {
        final updatedUsers = day.users.map((u) {
          return u.tags.contains(tagName)
              ? u.copyWith(
                  tags: [...u.tags.where((t) => t != tagName), newTagName],
                )
              : u;
        }).toList();
        updatedDays.add(day.copyWith(users: updatedUsers));
      }
      updatedWeeks.add(week.copyWith(days: updatedDays));
    }

    return updatedWeeks;
  }
}
