// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:jambu/calendar/model/calendar_day.dart';

class CalendarWeek extends Equatable {
  const CalendarWeek({
    required this.days,
  });

  final List<CalendarDay> days;

  List<DateTime> get recommendedDates => [];

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
