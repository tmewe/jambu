import 'package:flutter/material.dart';
import 'package:jambu/calendar/util/util.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/onboarding/widgets/weekday_selector.dart';

typedef ConfirmCallback = void Function(List<int>);

class RegularAttendancesOnboarding extends StatefulWidget {
  const RegularAttendancesOnboarding({
    required this.onConfirmTap,
    super.key,
  });

  final ConfirmCallback onConfirmTap;

  @override
  State<RegularAttendancesOnboarding> createState() =>
      _RegularAttendancesOnboardingState();
}

class _RegularAttendancesOnboardingState
    extends State<RegularAttendancesOnboarding> {
  final weekdays = <int>[];

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
                      setState(() {
                        if (weekdays.contains(weekday)) {
                          weekdays.remove(weekday);
                        } else {
                          weekdays.add(weekday);
                        }
                      });
                    },
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => widget.onConfirmTap(weekdays),
          child: const Text('Weiter'),
        ),
      ],
    );
  }
}
