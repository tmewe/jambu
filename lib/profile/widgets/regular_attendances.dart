import 'package:flutter/material.dart';
import 'package:jambu/widgets/widgets.dart';

class RegularAttendances extends StatelessWidget {
  const RegularAttendances({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'An welchen Tagen bist Du normalerweise jede Woche im Büro',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        RegularAttendancesSelector(
          selectedWeekdays: const [],
          onWeekdayTap: (_) {},
        ),
      ],
    );
  }
}
