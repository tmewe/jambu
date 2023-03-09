import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/model/model.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(CalendarState()) {
    on<CalendarRequested>(_onCalendarRequested);
  }

  final FirestoreRepository _firestoreRepository;

  FutureOr<void> _onCalendarRequested(
    CalendarRequested event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: CalendarStatus.loading));
    final attendances = await _firestoreRepository.getAttendances();
    emit(
      state.copyWith(status: CalendarStatus.success, attendances: attendances),
    );
  }
}
