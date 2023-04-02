import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/widgets/calender_item.dart';
import 'package:jambu/extension/datetime_extension.dart';

class CalendarDayColumn extends StatelessWidget {
  const CalendarDayColumn({
    required this.day,
    required this.tags,
    required this.width,
    super.key,
  });

  final CalendarDay day;
  final List<String> tags;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          if (day.reason != null) Text(day.reason!),
          Switch(
            value: day.isUserAttending,
            onChanged: (value) {
              context.read<CalendarBloc>().add(
                    CalendarAttendanceUpdate(
                      date: day.date.midnight,
                      isAttending: value,
                      reason: day.reason,
                    ),
                  );
            },
          ),
          Text(day.date.weekdayString),
          Text(DateFormat('dd').format(day.date)),
          ...day.users.map(
            (user) => CalendarItem(
              user: user,
              tags: tags,
              onCreateTag: (tag, userId) {
                context.read<CalendarBloc>().add(
                      CalendarAddTag(
                        tagName: tag,
                        userId: user.id,
                      ),
                    );
              },
              onRemoveTag: (tag, userId) {
                context.read<CalendarBloc>().add(
                      CalendarRemoveTag(
                        tagName: tag,
                        userId: user.id,
                      ),
                    );
              },
              onUpdateTagName: (oldName, newName) {
                context.read<CalendarBloc>().add(
                      CalendarUpdateTagName(
                        tagName: oldName,
                        newTagName: newName,
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
