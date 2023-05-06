import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        const SelectableText('Schritt 1/3'),
        const SizedBox(height: 50),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Servus',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              WidgetSpan(
                child: SvgPicture.asset(
                  'assets/images/waving_hand.svg',
                  width: 50,
                ),
              ),
            ],
          ),
        ),
        SelectableText(
          'Wilkommen bei jambu',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),
        SelectableText(
          'jambu unterstützt dich dabei den Überblick zu behalten, '
          'wann deine Kolleg*innen im Büro sein werden.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 20),
        const SelectableText(
          'Auf Basis deines Outlook Kalenders kann jambu dir vorschlagen, an '
          'welchen Tagen du wahrscheinlich im Büro bist und an welchen nicht. '
          'Für einen noch schnelleren Überblick synchronisiert jambu deine '
          'Anwesenheiten mit Outlook.',
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton.tonal(
              onPressed: onConfirmTap,
              child: const Text('Ok cool'),
            ),
          ],
        ),
      ],
    );
  }
}
