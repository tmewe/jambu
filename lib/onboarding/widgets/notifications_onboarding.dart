import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NotificationsOnboarding extends StatelessWidget {
  const NotificationsOnboarding({
    required this.isLoading,
    required this.onConfirmTap,
    required this.onDeclineTap,
    required this.onBackTap,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onConfirmTap;
  final VoidCallback onDeclineTap;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectableText('Schritt 3/3'),
        const SizedBox(height: 50),
        Row(
          children: [
            const Icon(Icons.notifications_active, size: 40),
            const SizedBox(width: 10),
            SelectableText(
              'Benachrichtigungen',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
            'Darf jambu dir 1x pro Woche eine Benachrichtigung schicken, '
            'um dich daran zu errinern, deine Anwesenheit zu aktualisieren?'),
        const SizedBox(height: 10),
        const Text(
          'Bitte überprüfe auch ob dein Browser '
          'dir Benachrichtigungen schicken darf.',
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onBackTap,
              child: const Text('Zurück'),
            ),
            const SizedBox(width: 40),
            TextButton(
              onPressed: onDeclineTap,
              child: const Text('Später vielleicht'),
            ),
            const SizedBox(width: 10),
            FilledButton.tonal(
              onPressed: onConfirmTap,
              child: !isLoading
                  ? const Text('Auf jeden Fall')
                  : const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
