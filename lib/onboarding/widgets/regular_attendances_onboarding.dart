import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jambu/calendar/util/util.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/onboarding/widgets/weekday_selector.dart';

typedef UpdateCallback = void Function(List<int>);

class RegularAttendancesOnboarding extends StatelessWidget {
  const RegularAttendancesOnboarding({
    required this.onDayTap,
    required this.onConfirmTap,
    this.weekdays = const [],
    super.key,
  });

  final List<int> weekdays;
  final UpdateCallback onDayTap;
  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('An welchen Tagen bist Du normalerweise jede Woche im Büro'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: WeekFromDate(DateTime.now())
              .workingDays
              .map(
                (date) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: WeekdaySelector(
                    weekday: date.weekdayStringShort,
                    isSelected: weekdays.contains(date.weekday),
                    onTap: () {
                      final weekday = date.weekday;
                      if (weekdays.contains(weekday)) {
                        onDayTap(
                          weekdays.whereNot((e) => e == weekday).toList(),
                        );
                      } else {
                        onDayTap([...weekdays, weekday]);
                      }
                    },
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onConfirmTap,
          child: const Text('Weiter'),
        ),
      ],
    );
  }
}
