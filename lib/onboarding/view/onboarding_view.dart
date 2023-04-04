import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/onboarding/bloc/onboarding_bloc.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Onboarding'),
            TextButton(
              onPressed: () =>
                  context.read<OnboardingBloc>().add(OnboardingCompleted()),
              child: const Text('Fertig'),
            ),
          ],
        ),
      ),
    );
  }
}
