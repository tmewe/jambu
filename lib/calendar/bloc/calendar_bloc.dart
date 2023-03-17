import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required CalendarRepository calendarRepository,
  })  : _calendarRepository = calendarRepository,
        super(const CalendarState()) {
    on<CalendarRequested>(_onCalendarRequested);
    on<CalendarAttendanceUpdate>(_onCalenderAttendanceUpdate);
    on<CalendarGoToWeek>(_onCalendarGoToWeek);
    on<CalendarFilterUpdate>(
      _onCalendarFilterUpdate,
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .switchMap(mapper);
      },
    );
  }

  final CalendarRepository _calendarRepository;

  FutureOr<void> _onCalendarRequested(
    CalendarRequested event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: CalendarStatus.loading));
    final weeks = await _calendarRepository.fetchCalendar(filter: state.filter);
    emit(
      state.copyWith(
        status: CalendarStatus.success,
        weeks: weeks,
      ),
    );
  }

  FutureOr<void> _onCalenderAttendanceUpdate(
    CalendarAttendanceUpdate event,
    Emitter<CalendarState> emit,
  ) async {
    final weeks = await _calendarRepository.updateAttendanceAt(
      date: event.date,
      isAttending: event.isAttending,
    );

    if (weeks.isNotEmpty) {
      emit(state.copyWith(weeks: weeks));
    }
  }

  FutureOr<void> _onCalendarGoToWeek(
    CalendarGoToWeek event,
    Emitter<CalendarState> emit,
  ) async {
    if (event.weekNumber < 0 || event.weekNumber > 3) return;
    emit(state.copyWith(selectedWeek: event.weekNumber));
  }

  FutureOr<void> _onCalendarFilterUpdate(
    CalendarFilterUpdate event,
    Emitter<CalendarState> emit,
  ) async {
    final filter = CalendarFilter(
      search: event.searchText ?? '',
      tags: event.tags,
    );
    final filteredWeeks = await _calendarRepository.updateFilter(filter);
    emit(state.copyWith(weeks: filteredWeeks, filter: filter));
  }
}
