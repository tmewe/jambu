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
    on<CalendarSearchTextUpdate>(
      _onCalendarSearchTextUpdate,
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .switchMap(mapper);
      },
    );
    on<CalendarTagFilterUpdate>(_onCalendarTagFilterUpdate);
    on<CalendarAddTag>(_onCalendarAddTag);
    on<CalendarRemoveTag>(_onCalendarRemoveTag);
  }

  final CalendarRepository _calendarRepository;

  FutureOr<void> _onCalendarRequested(
    CalendarRequested event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: CalendarStatus.loading));

    final weeks = await _calendarRepository.fetchCalendar(filter: state.filter);
    final tags = await _calendarRepository.fetchTags();

    // final filteredWeeks = _calendarRepository.updateFilter(
    //   filter: state.filter,
    //   weeks: weeks,
    // );
    emit(
      state.copyWith(
        status: CalendarStatus.success,
        weeks: weeks,
        tags: tags,
      ),
    );
  }

  FutureOr<void> _onCalenderAttendanceUpdate(
    CalendarAttendanceUpdate event,
    Emitter<CalendarState> emit,
  ) async {
    final weeks = _calendarRepository.updateAttendanceAt(
      date: event.date,
      isAttending: event.isAttending,
      weeks: state.weeks,
      filter: state.filter,
    );

    emit(state.copyWith(weeks: weeks));
  }

  FutureOr<void> _onCalendarGoToWeek(
    CalendarGoToWeek event,
    Emitter<CalendarState> emit,
  ) async {
    if (event.weekNumber < 0 || event.weekNumber > 3) return;
    emit(state.copyWith(selectedWeek: event.weekNumber));
  }

  FutureOr<void> _onCalendarSearchTextUpdate(
    CalendarSearchTextUpdate event,
    Emitter<CalendarState> emit,
  ) {
    final filter = CalendarFilter(
      search: event.searchText,
      tags: state.filter.tags,
    );

    emit(state.copyWith(filter: filter));
  }

  FutureOr<void> _onCalendarTagFilterUpdate(
    CalendarTagFilterUpdate event,
    Emitter<CalendarState> emit,
  ) {
    final filter = CalendarFilter(
      search: state.filter.search,
      tags: event.tags,
    );

    emit(state.copyWith(filter: filter));
  }

  FutureOr<void> _onCalendarAddTag(
    CalendarAddTag event,
    Emitter<CalendarState> emit,
  ) async {
    // Don't do anything if user already got the tag
    final taggedUser = state.weeks.firstUserOrNull(event.userId);
    if (taggedUser != null && taggedUser.tags.contains(event.tagName)) return;

    // Dont't do anything if tag name is empty
    if (event.tagName.isEmpty) return;

    final weeks = await _calendarRepository.addTagToUser(
      weeks: state.weeks,
      tagName: event.tagName,
      userId: event.userId,
    );

    emit(
      state.copyWith(
        weeks: weeks,
        tags: {...state.tags, event.tagName}.toList(),
      ),
    );
  }

  FutureOr<void> _onCalendarRemoveTag(
    CalendarRemoveTag event,
    Emitter<CalendarState> emit,
  ) async {
    final weeks = await _calendarRepository.removeTagFromUser(
      weeks: state.weeks,
      tag: event.tagName,
      userId: event.userId,
    );

    emit(
      state.copyWith(
        weeks: weeks,
      ),
    );
  }
}
