import 'package:jambu/calendar/model/model.dart';

class UpdateFavorite {
  const UpdateFavorite({
    required this.userId,
    required this.isFavorite,
    required this.weeks,
  });

  final String userId;
  final bool isFavorite;
  final List<CalendarWeek> weeks;

  List<CalendarWeek> call() {
    final updatedWeeks = <CalendarWeek>[];
    for (final week in weeks) {
      final updatedDays = <CalendarDay>[];
      for (final day in week.days) {
        final updatedUsers = day.users
            .map((u) => u.id == userId ? u.copyWith(isFavorite: isFavorite) : u)
            .toList();
        updatedDays.add(day.copyWith(users: updatedUsers));
      }
      updatedWeeks.add(week.copyWith(days: updatedDays));
    }
    return updatedWeeks;
  }
}
