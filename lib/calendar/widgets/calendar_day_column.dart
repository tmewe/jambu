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
    this.isBestChoice = false,
    super.key,
  });

  final CalendarDay day;
  final List<String> tags;
  final bool isBestChoice;
  final double width;

  @override
  Widget build(BuildContext context) {
    var reason = day.reason ?? '';
    if (day.isHoliday) {
      reason = '🏖️ $reason';
    }
    return SizedBox(
      width: width,
      child: Column(
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
          ...day.sortedUsers.map(
            (user) => CalendarItem(
              user: user,
              tags: tags,
              onAddTag: (tag, userId) {
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
              onUpdateFavorite: (isFavorite) {
                context.read<CalendarBloc>().add(
                      CalenderUpdateFavorite(
                        userId: user.id,
                        isFavorite: isFavorite,
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
