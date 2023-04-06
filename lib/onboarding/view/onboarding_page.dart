import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/onboarding/bloc/onboarding_bloc.dart';
import 'package:jambu/onboarding/view/onboarding_view.dart';
import 'package:jambu/repository/repository.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(
        userRepository: context.read<UserRepository>(),
        notificationsRepository: context.read<NotificationsRepository>(),
      ),
      child: const OnboardingView(),
    );
  }
}
