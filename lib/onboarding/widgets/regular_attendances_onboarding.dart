import 'package:flutter/material.dart';
import 'package:jambu/widgets/widgets.dart';

typedef UpdateCallback = void Function(List<int>);

class RegularAttendancesOnboarding extends StatelessWidget {
  const RegularAttendancesOnboarding({
    required this.onDayTap,
    required this.onBackTap,
    required this.onConfirmTap,
    this.weekdays = const [],
    super.key,
  });

  final List<int> weekdays;
  final UpdateCallback onDayTap;
  final VoidCallback onBackTap;
  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectableText('Schritt 2/3'),
        const SizedBox(height: 50),
        Row(
          children: [
            const Icon(Icons.calendar_month, size: 40),
            const SizedBox(width: 10),
            SelectableText(
              'Regelmäßige Anwesenheit',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        const SizedBox(height: 30),
        const SelectableText(
          'An welchen Tagen bist Du normalerweise jede Woche im Büro?',
        ),
        const SizedBox(height: 30),
        RegularAttendancesSelector(
          selectedWeekdays: weekdays,
          onWeekdayTap: onDayTap,
          alignment: MainAxisAlignment.center,
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onBackTap,
              child: const Text('Zurück'),
            ),
            const SizedBox(width: 10),
            FilledButton.tonal(
              onPressed: onConfirmTap,
              child: const Text('Weiter'),
            ),
          ],
        ),
      ],
    );
  }
}
