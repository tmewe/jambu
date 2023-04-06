import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jambu/calendar/util/util.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/widgets/weekday_selector.dart';

typedef WeekdaySelectedCallback = void Function(List<int>);

class RegularAttendancesSelector extends StatelessWidget {
  const RegularAttendancesSelector({
    required this.selectedWeekdays,
    required this.onWeekdayTap,
    this.alignment = MainAxisAlignment.start,
    super.key,
  });

  final List<int> selectedWeekdays;
  final WeekdaySelectedCallback onWeekdayTap;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: WeekFromDate(DateTime.now())
          .workingDays
          .map(
            (date) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: WeekdaySelector(
                weekday: date.weekdayStringShort,
                isSelected: selectedWeekdays.contains(date.weekday),
                onTap: () {
                  final weekday = date.weekday;
                  if (selectedWeekdays.contains(weekday)) {
                    onWeekdayTap(
                      selectedWeekdays.whereNot((e) => e == weekday).toList(),
                    );
                  } else {
                    onWeekdayTap([...selectedWeekdays, weekday]);
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
