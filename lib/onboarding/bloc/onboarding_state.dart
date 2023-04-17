part of 'onboarding_bloc.dart';

enum OnboardingStatus { ongoing, notificationsRequested, completed }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = OnboardingStatus.ongoing,
    this.regularWeekdays = const [],
  });

  final OnboardingStatus status;
  final List<int> regularWeekdays;

  @override
  List<Object> get props => [
        status,
        regularWeekdays,
      ];

  OnboardingState copyWith({
    OnboardingStatus? status,
    List<int>? regularWeekdays,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      regularWeekdays: regularWeekdays ?? this.regularWeekdays,
    );
  }
}
