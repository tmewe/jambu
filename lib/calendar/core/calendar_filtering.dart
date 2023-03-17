import 'package:jambu/calendar/model/model.dart';

class CalendarFiltering {
  CalendarFiltering({
    required this.filter,
    required this.weeks,
  });

  final CalendarFilter filter;
  final List<CalendarWeek> weeks;

  List<CalendarWeek> call() {
    if (filter.search.isEmpty && filter.tags.isEmpty) {
      return weeks;
    }

    final filteredWeeks = <CalendarWeek>[];
    for (final week in weeks) {
      final filteredDays = <CalendarDay>[];
      for (final day in week.days) {
        final filteredUsers = day.users.where((user) {
          final searchFilter =
              user.name.toLowerCase().contains(filter.search.toLowerCase());
          final tagFilter = user.tags.toSet().containsAll(filter.tags);

          return searchFilter && tagFilter;
        }).toList();
        filteredDays.add(day.copyWith(users: filteredUsers));
      }
      filteredWeeks.add(week.copyWith(days: filteredDays));
    }
    return filteredWeeks;
  }
}
