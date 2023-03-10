import 'package:flutter/material.dart';
import 'package:jambu/calendar/model/model.dart';

extension UpdateWeek on List<CalendarWeek> {
  List<CalendarWeek> updateWeek(CalendarWeek week) {
    final filteredWeeks = where((e) {
      return !DateUtils.isSameDay(e.days.first.date, week.days.first.date);
    });
    final newWeeks = [...filteredWeeks, week]..sort((a, b) {
        return a.days.first.date.compareTo(b.days.first.date);
      });
    return newWeeks;
  }
}
