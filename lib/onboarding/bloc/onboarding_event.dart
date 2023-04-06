part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingUpdateAttendances extends OnboardingEvent {
  const OnboardingUpdateAttendances({required this.weekdays});

  final List<int> weekdays;

  @override
  List<Object> get props => [weekdays];
}

class OnboardingCompleted extends OnboardingEvent {}
