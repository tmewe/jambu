import 'package:jambu/calendar/util/util.dart';

class MonthFromDate {
  MonthFromDate(DateTime date) {
    // Start with next week if date is at a weekend
    if (date.weekday == 6) {
      // Add two days if date is saturday
      this.date = date.add(const Duration(days: 2));
    } else if (date.weekday == 7) {
      // Add two days if date is saturday
      this.date = date.add(const Duration(days: 1));
    } else {
      this.date = date;
    }
  }

  late final DateTime date;

  static const int weeksInMonth = 4;
  static const int daysInWeek = 7;

  List<WeekFromDate> get weeks {
    final weeks = <WeekFromDate>[];
    for (var i = 0; i < weeksInMonth; i++) {
      final dateInWeek = date.add(Duration(days: i * daysInWeek));
      weeks.add(WeekFromDate(dateInWeek));
    }
    return weeks;
  }
}
