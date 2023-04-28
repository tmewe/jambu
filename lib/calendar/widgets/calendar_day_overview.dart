import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/extension/extension.dart';

class CalendarDayOverview extends StatelessWidget {
  const CalendarDayOverview({
    required this.day,
    required this.tags,
    this.isBestChoice = false,
    super.key,
  });

  final CalendarDay day;
  final List<String> tags;
  final bool isBestChoice;

  @override
  Widget build(BuildContext context) {
    var reason = day.reason ?? '';
    if (day.isHoliday) {
      reason = '🏖️ $reason';
    }

    return Column(
      children: [
        Text(isBestChoice ? 'Optimaler Tag' : ''),
        Text(reason),
        Switch(
          value: day.isUserAttending,
          onChanged: !day.isHoliday
              ? (value) {
                  context.read<CalendarBloc>().add(
                        CalendarAttendanceUpdate(
                          date: day.date.midnight,
                          isAttending: value,
                          reason: day.reason,
                        ),
                      );
                }
              : null,
        ),
        Text(day.date.weekdayString),
        Text(DateFormat('dd').format(day.date)),
      ],
    );
  }
}
