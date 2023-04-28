import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final reason = day.reason;
    final weekday = day.date.weekdayString.characters.take(2).string;
    final formattedDate = DateFormat('dd').format(day.date);
    final isUserAttending = day.isUserAttending;
    final bgColor = isUserAttending
        ? AppColors.brightGreen
        : isBestChoice
            ? AppColors.brightPink
            : Colors.transparent;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: CornerRadius.m,
          topRight: CornerRadius.m,
        ),
        color: bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _DateAndReason(
                weekday: weekday,
                formattedDate: formattedDate,
                reason: reason,
              ),
              _BestChoiceText(isBestChoice: isBestChoice),
            ],
          ),
          if (!day.isHoliday)
            _CheckmarkButton(
              isSelected: isUserAttending,
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
          if (day.isHoliday) _HolidayText(reason: reason)
        ],
      ),
    );
  }
}

class _HolidayText extends StatelessWidget {
  const _HolidayText({
    required this.reason,
  });

  final String? reason;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: SvgPicture.asset(
              'assets/images/beach.svg',
              width: 25,
            ),
          ),
          TextSpan(
            text: ' $reason',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  // fontWeight: FontWeight.bold,
                  color: AppColors.slateGrey,
                ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _BestChoiceText extends StatelessWidget {
  const _BestChoiceText({
    required this.isBestChoice,
  });

  final bool isBestChoice;

  @override
  Widget build(BuildContext context) {
    return Text(
      isBestChoice ? 'Optimaler Tag' : '',
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: AppColors.slateGrey,
          ),
    );
  }
}

class _DateAndReason extends StatelessWidget {
  const _DateAndReason({
    required this.weekday,
    required this.formattedDate,
    required this.reason,
  });

  final String weekday;
  final String formattedDate;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$weekday $formattedDate',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.slateGrey,
              ),
        ),
        if (reason != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Tooltip(
              message: reason,
              child: const Icon(
                Icons.info,
                size: 17,
                color: AppColors.slateGrey,
              ),
            ),
          )
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
