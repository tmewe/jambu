import 'package:app_ui/app_ui.dart';
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
        _CheckmarkButton(
          isSelected: day.isUserAttending,
          onTap: (bool value) {
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
      ],
    );
  }
}

class _CheckmarkButton extends StatelessWidget {
  const _CheckmarkButton({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final void Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? AppColors.white : AppColors.platinumGrey;
    final bgColor = isSelected ? AppColors.green : AppColors.seasaltGrey;
    final borderColor = isSelected ? AppColors.green : AppColors.platinumGrey;

    return Material(
      color: bgColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(
          side: BorderSide(
            width: 3,
            color: borderColor,
          ),
        ),
        onTap: () => onTap(!isSelected),
        child: Ink(
          width: 55,
          height: 55,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child: Icon(
              Icons.check,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
