import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/ms_graph/repository/respository.dart';

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
                context.read<MSGraphRepository>().me();
              },
              child: const Text('Me'),
            ),
            TextButton(
              onPressed: () {
                context.read<MSGraphRepository>().events();
              },
              child: const Text('Events'),
            ),
          ],
        ),
      ),
    );
  }
}
