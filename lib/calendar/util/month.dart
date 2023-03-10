import 'package:jambu/calendar/util/util.dart';

class MonthFromDate {
  const MonthFromDate(this.date);

  final DateTime date;

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
