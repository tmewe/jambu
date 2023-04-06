import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/backend/backend.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(const OnboardingState()) {
    on<OnboardingUpdateAttendances>(_onOnboardingUpdateAttendances);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  final FirestoreRepository _firestoreRepository;

  FutureOr<void> _onOnboardingUpdateAttendances(
    OnboardingUpdateAttendances event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(regularWeekdays: event.weekdays));
  }

  FutureOr<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await _firestoreRepository.completeOnboarding();
  }
}
