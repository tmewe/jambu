import 'package:flutter/material.dart';
import 'package:jambu/model/model.dart';

extension AttendanceAtDate on List<Attendance> {
  Attendance getAtDate(DateTime date) {
    return firstWhere(
      (e) => DateUtils.isSameDay(e.date, date),
      orElse: () => Attendance(date: date),
    );
  }
}
