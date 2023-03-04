import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '''Du wurdest erfolgreich abgemeldet. Schließe den Browsertab oder melde dich erneut an.''',
            ),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Anmelden'),
            ),
          ],
        ),
      ),
    );
  }
}
