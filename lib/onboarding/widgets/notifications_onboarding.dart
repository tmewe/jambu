import 'package:flutter/material.dart';

class NotificationsOnboarding extends StatelessWidget {
  const NotificationsOnboarding({
    required this.onConfirmTap,
    required this.onDeclineTap,
    required this.onBackTap,
    super.key,
  });

  final VoidCallback onConfirmTap;
  final VoidCallback onDeclineTap;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Darf jambu dir Benachrichtigungen schicken?'),
        const Text(
          'Bitte überprüfe auch ob dein Browser '
          'dir Benachrichtigungen schicken darf.',
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
              onPressed: onBackTap,
              child: const Text('Zurück'),
            ),
            const Spacer(),
            TextButton(
              onPressed: onDeclineTap,
              child: const Text('Später vielleicht'),
            ),
            FilledButton.tonal(
              onPressed: onConfirmTap,
              child: const Text('Bestätigen'),
            ),
          ],
        ),
      ],
    );
  }
}
