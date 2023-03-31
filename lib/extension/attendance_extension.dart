import 'package:flutter/material.dart';
import 'package:jambu/model/model.dart';

extension AttendanceAtDate on List<Attendance> {
  Attendance getAtDate(DateTime date) => firstWhere(
        (e) => DateUtils.isSameDay(e.date, date),
        orElse: () => Attendance(date: date),
      );

  List<Attendance> whereUserId(String id) =>
      where((a) => a.userIds.contains(Entry(userId: id))).toList();
}
