import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/notifications/notifications.dart';
import 'package:jambu/user/user.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
  })  : _userRepository = userRepository,
        _notificationsRespository = notificationsRepository,
        super(const OnboardingState()) {
    on<OnboardingUpdateAttendances>(_onOnboardingUpdateAttendances);
    on<OnboardingRequestNotifications>(_onOnboardingRequestNotifications);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRespository;

  FutureOr<void> _onOnboardingUpdateAttendances(
    OnboardingUpdateAttendances event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(regularWeekdays: event.weekdays));
  }

  FutureOr<void> _onOnboardingRequestNotifications(
    OnboardingRequestNotifications event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.notificationsRequested));
    await _notificationsRespository.requestNotifications();
    add(OnboardingCompleted());
  }

  FutureOr<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await _userRepository.completeOnboarding(
      regularAttendances: state.regularWeekdays,
    );
    emit(state.copyWith(status: OnboardingStatus.completed));
  }
}
