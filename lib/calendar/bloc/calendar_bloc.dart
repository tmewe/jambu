import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required CalendarRepository calendarRepository,
  })  : _calendarRepository = calendarRepository,
        super(CalendarState()) {
    on<CalendarRequested>(_onCalendarRequested);
    on<CalendarAttendanceUpdate>(_onCalenderAttendanceUpdate);
  }

  final CalendarRepository _calendarRepository;

  FutureOr<void> _onCalendarRequested(
    CalendarRequested event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: CalendarStatus.loading));
    final attendances = await _calendarRepository.getAttendances();
    final userAttendances = await _calendarRepository.getAttendancesForUser();
    emit(
      state.copyWith(
        status: CalendarStatus.success,
        attendances: attendances,
        userAttendances: userAttendances,
      ),
    );
  }

  FutureOr<void> _onCalenderAttendanceUpdate(
    CalendarAttendanceUpdate event,
    Emitter<CalendarState> emit,
  ) async {
    final List<DateTime> updatedAttendances;
    if (event.isAttending) {
      updatedAttendances = [...state.userAttendances, event.date];
    } else {
      updatedAttendances = state.userAttendances
          .where((d) => !DateUtils.isSameDay(d, event.date))
          .toList();
    }
    emit(state.copyWith(userAttendances: updatedAttendances));
    await _calendarRepository.updateAttendanceAt(
      date: event.date,
      isAttending: event.isAttending,
    );
  }
}
