import 'package:flutter/material.dart';

class WelcomeOnboarding extends StatelessWidget {
  const WelcomeOnboarding({
    required this.onConfirmTap,
    super.key,
  });

  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectableText('Schritt 1/4'),
        const SizedBox(height: 50),
        SelectableText(
          'Servus 👋\nWilkommen bei jambu',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 30),
        const SelectableText(
          'jambu unterstützt dich dabei den Überblick zu behalten, '
          'wann deine Kolleg*innen im Büro sein werden.\n'
          'Auf Basis deines Outlook Kalenders kann jambu dir vorschlagen, an '
          'welchen Tagen du wahrscheinlich im Büro bist und an welchen nicht.',
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton.tonal(
              onPressed: onConfirmTap,
              child: const Text('Los gehts'),
            ),
          ],
        ),
      ],
    );
  }
}
