import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/repository/repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required FirestoreRepository firestoreRepository,
    required NotificationsRepository notificationsRepository,
  })  : _firestoreRepository = firestoreRepository,
        _notificationsRespository = notificationsRepository,
        super(const OnboardingState()) {
    on<OnboardingUpdateAttendances>(_onOnboardingUpdateAttendances);
    on<OnboardingRequestNotifications>(_onOnboardingRequestNotifications);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  final FirestoreRepository _firestoreRepository;
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
  ) async {}

  FutureOr<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await _firestoreRepository.completeOnboarding();
  }
}
