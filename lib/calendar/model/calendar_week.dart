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

  List<DateTime> get recommendedDates => [];

  List<int> get bestChoices {
    final map = {
      for (final day in days)
        day.date.weekday: day.users.where((u) => u.isFavorite).length
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
    final filteredDays = days.where((e) {
      return !DateUtils.isSameDay(e.date, day.date);
    });
    final newDays = [...filteredDays, day]
      ..sort((a, b) => a.date.compareTo(b.date));

    return copyWith(
      days: newDays,
    );
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

extension WeekFromDate on List<CalendarWeek> {
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
    final filteredWeeks = where((e) {
      return !DateUtils.isSameDay(e.days.first.date, week.days.first.date);
    });
    final newWeeks = [...filteredWeeks, week]..sort((a, b) {
        return a.days.first.date.compareTo(b.days.first.date);
      });
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
    final week = getWeekFromDate(date);
    if (week == null) {
      return null;
    }
    try {
      return week.days.firstWhere((day) => DateUtils.isSameDay(day.date, date));
    } catch (_) {
      return null;
    }
  }
}

extension FindUser on List<CalendarWeek> {
  // Returns the day on a given day in a list of weeks or null
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
