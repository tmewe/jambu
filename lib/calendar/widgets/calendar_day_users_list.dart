import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/widgets/calender_item.dart';

class CalendarDayUsersList extends StatelessWidget {
  const CalendarDayUsersList({
    required this.day,
    required this.tags,
    super.key,
  });

  final CalendarDay day;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    var reason = day.reason ?? '';
    if (day.isHoliday) {
      reason = '🏖️ $reason';
    }

    final sortedUsers = day.sortedUsers;
    return ListView.separated(
      itemBuilder: (context, index) {
        final user = sortedUsers[index];
        return CalendarItem(
          user: user,
          tags: tags,
          borderRadius: index == sortedUsers.length - 1
              ? const BorderRadius.only(
                  bottomLeft: CornerRadius.m,
                  bottomRight: CornerRadius.m,
                )
              : BorderRadius.zero,
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
          onUpdateFavorite: ({required bool isFavorite}) {
            context.read<CalendarBloc>().add(
                  CalenderUpdateFavorite(
                    userId: user.id,
                    isFavorite: isFavorite,
                  ),
                );
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: sortedUsers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
