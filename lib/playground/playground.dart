import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/repository/repository.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.read<FirestoreRepository>().updateAttendanceAt(
                      date: DateTime.now(),
                      isAttending: true,
                    );
              },
              child: const Text('Ich bin heute im Büro'),
            ),
            TextButton(
              onPressed: () {
                context.read<MSGraphRepository>().me();
              },
              child: const Text('Meine Daten'),
            ),
            TextButton(
              onPressed: () {
                context.read<MSGraphRepository>().calendars();
              },
              child: const Text('Kalender'),
            ),
            TextButton(
              onPressed: () {
                context.read<MSGraphRepository>().createCalendar(
                      name: 'Anwesenheiten',
                      color: Colors.orange,
                    );
              },
              child: const Text('Kalender erstellen'),
            ),
            TextButton(
              onPressed: () {
                context.read<MSGraphRepository>().events();
              },
              child: const Text('Termine'),
            ),
            TextButton(
              onPressed: () {
                context.read<MSGraphRepository>().createEventAt(
                      dateTime: DateTime.now(),
                    );
              },
              child: const Text('Termin erstellen'),
            ),
            TextButton(
              onPressed: () {
                context.read<UserRepository>().logout();
              },
              child: const Text('Abmelden'),
            ),
          ],
        ),
      ),
    );
  }
}
