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
    required this.isBestChoice,
    required this.isColorBlind,
    super.key,
  });

  final CalendarDay day;
  final List<String> tags;
  final bool isBestChoice;
  final bool isColorBlind;

  @override
  Widget build(BuildContext context) {
    final reason = day.reason;
    final weekday = day.date.weekdayString.characters.take(2).string;
    final formattedDate = DateFormat('dd').format(day.date);
    final isUserAttending = day.isUserAttending;
    final bgColor = isUserAttending
        ? AppColors.attendingColor(isColorBlind: isColorBlind)
        : isBestChoice
            ? AppColors.bestDayColor(isColorBlind: isColorBlind)
            : AppColors.seasaltGrey;

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
                isHoliday: day.isHoliday,
                isSelected: isUserAttending,
              ),
              _BestChoiceText(isBestChoice: isBestChoice),
            ],
          ),
          if (!day.isHoliday)
            _CheckmarkButton(
              isSelected: isUserAttending,
              isColorBlind: isColorBlind,
              onTap: ({required isSelected}) {
                context.read<CalendarBloc>().add(
                      CalendarAttendanceUpdate(
                        date: day.date.midnight,
                        isAttending: isSelected,
                        reason: day.reason,
                      ),
                    );
              },
            ),
          if (day.isHoliday)
            Expanded(
              child: Center(
                child: _HolidayText(reason: reason),
              ),
            )
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
    return SelectableText(
      isBestChoice ? 'Guter Tag' : '',
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
    required this.isHoliday,
    required this.isSelected,
  });

  final String weekday;
  final String formattedDate;
  final String? reason;
  final bool isHoliday;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(
          '$weekday $formattedDate',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.outerSpaceGrey
                    : AppColors.frenchGrey,
              ),
        ),
        if (reason != null && !isHoliday)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Tooltip(
              message: reason,
              child: Icon(
                Icons.info,
                size: 17,
                color: isSelected
                    ? AppColors.outerSpaceGrey
                    : AppColors.frenchGrey,
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
    required this.isColorBlind,
    required this.onTap,
  });

  final bool isSelected;
  final bool isColorBlind;
  final void Function({required bool isSelected}) onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? AppColors.checkmarkColor(isColorBlind: isColorBlind)
        : AppColors.platinumGrey;
    final borderColor = isSelected
        ? AppColors.checkmarkColor(isColorBlind: isColorBlind)
        : AppColors.frenchGrey;

    return Material(
      color: bgColor,
      shape: const CircleBorder(),
      elevation: isSelected ? 2 : 0,
      child: InkWell(
        customBorder: CircleBorder(
          side: BorderSide(
            width: 3,
            color: borderColor,
          ),
        ),
        onTap: () => onTap(isSelected: !isSelected),
        child: Ink(
          width: 55,
          height: 55,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: const Center(
            child: Icon(Icons.check, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
