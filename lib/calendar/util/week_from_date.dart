import 'package:equatable/equatable.dart';

class WeekFromDate extends Equatable {
  const WeekFromDate(this.date);

  final DateTime date;

  List<DateTime> get workingDays {
    final dates = <DateTime>[];
    final days = List<int>.generate(5, (i) => i + 1);
    final weekday = date.weekday;
    for (final day in days) {
      final difference = weekday - day;
      if (difference > 0) {
        dates.add(date.subtract(Duration(days: difference)));
      } else if (difference < 0) {
        dates.add(date.add(Duration(days: -difference)));
      } else {
        dates.add(date);
      }
    }
    return dates;
  }

  @override
  List<Object> get props => [date];
}
