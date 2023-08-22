import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/extension/extension.dart';

class CalendarWeek extends Equatable {
  const CalendarWeek({
    required this.days,
  });

  final List<CalendarDay> days;

  List<int> get bestChoices {
    final map = {
      for (final day in days)
        day.date.weekday: day.users.where((u) => u.isFavorite).length,
    };
    return map.maxValues;
  }

  CalendarDay? dayAtDate(DateTime date) {
    final filteredDays = days.where((day) {
      return DateUtils.isSameDay(day.date, date);
    });
    return filteredDays.isNotEmpty ? filteredDays.first : null;
  }

  CalendarWeek updateDay(CalendarDay day) {
    final dayInWeek = days.firstWhereOrNull((d) {
      return DateUtils.isSameDay(d.date, day.date);
    });

    // ignore: avoid_returning_this
    if (dayInWeek == null) return this;

    final filteredDays = days.where((day) => day != dayInWeek);

    final newDays = [...filteredDays, day]
      ..sort((a, b) => a.date.compareTo(b.date));

    return copyWith(days: newDays);
  }

  CalendarWeek copyWith({
    List<CalendarDay>? days,
  }) {
    return CalendarWeek(
      days: days ?? this.days,
    );
  }

  @override
  List<Object> get props => [days];
}

extension CalendarWeekFromDate on List<CalendarWeek> {
  /// Returns the week which contains the date in a list of or null
  CalendarWeek? getWeekFromDate(DateTime date) {
    for (final week in this) {
      for (final day in week.days) {
        if (DateUtils.isSameDay(day.date, date)) {
          return week;
        }
      }
    }
    return null;
  }
}

extension UpdateWeek on List<CalendarWeek> {
  /// Updates a week in a list of weeks
  List<CalendarWeek> updateWeek(CalendarWeek week) {
    final weekInWeeks = firstWhereOrNull((w) {
      return DateUtils.isSameDay(w.days.first.date, week.days.first.date);
    });

    if (weekInWeeks == null) return this;

    remove(weekInWeeks);
    final newWeeks = [...this, week]
      ..sort((a, b) => a.days.first.date.compareTo(b.days.first.date));

    return newWeeks;
  }
}

extension UpdateDay on List<CalendarWeek> {
  /// Updates a day in a list of weeks
  List<CalendarWeek> updateDay(CalendarDay day) {
    final week = getWeekFromDate(day.date);
    if (week == null) {
      return this;
    }
    final updatedWeek = week.updateDay(day);
    return updateWeek(updatedWeek);
  }
}

extension DayAtDate on List<CalendarWeek> {
  // Returns the day on a given day in a list of weeks or null
  CalendarDay? dayAtDate(DateTime date) {
    for (final week in this) {
      final day = week.dayAtDate(date);
      if (day != null) return day;
    }
    return null;
  }
}

extension FindUser on List<CalendarWeek> {
  CalendarUser? firstUserOrNull(String userId) {
    CalendarUser? user;
    for (final week in this) {
      for (final day in week.days) {
        final foundUser = day.users.firstWhereOrNull((e) => e.id == userId);
        if (foundUser != null) return foundUser;
      }
    }
    return user;
  }
}
