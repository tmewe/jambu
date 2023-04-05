import 'package:flutter/material.dart';

class NotificationsOnboarding extends StatelessWidget {
  const NotificationsOnboarding({
    required this.onConfirmTap,
    required this.onDeclineTap,
    super.key,
  });

  final VoidCallback onConfirmTap;
  final VoidCallback onDeclineTap;

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
            TextButton(
              onPressed: onDeclineTap,
              child: const Text('Später vielleicht'),
            ),
            TextButton(
              onPressed: onConfirmTap,
              child: const Text('Bestätigen'),
            ),
          ],
        ),
      ],
    );
  }
}
