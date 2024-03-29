import 'package:flutter/material.dart';

extension DayString on DateTime {
  String get weekdayString {
    switch (weekday) {
      case 1:
        return 'Montag';
      case 2:
        return 'Dienstag';
      case 3:
        return 'Mittwoch';
      case 4:
        return 'Donnerstag';
      case 5:
        return 'Freitag';
      default:
        return '-';
    }
  }

  String get weekdayStringShort {
    switch (weekday) {
      case 1:
        return 'Mo';
      case 2:
        return 'Di';
      case 3:
        return 'Mi';
      case 4:
        return 'Do';
      case 5:
        return 'Fr';
      default:
        return '-';
    }
  }
}

extension Midnight on DateTime {
  DateTime get midnight {
    return DateTime(year, month, day);
  }
}

extension Noon on DateTime {
  DateTime get noon {
    return DateTime(year, month, day, 12);
  }
}

extension FirstDateOfWeek on DateTime {
  DateTime get firstDateOfWeek {
    return subtract(Duration(days: weekday - 1));
  }
}

extension IsSameDay on DateTime {
  bool isSameDay(DateTime date) {
    return DateUtils.isSameDay(this, date);
  }
}
