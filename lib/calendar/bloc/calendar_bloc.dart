import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required CalendarRepository calendarRepository,
  })  : _calendarRepository = calendarRepository,
        super(const CalendarState()) {
    on<CalendarRefresh>(_onCalendarRefresh);
    on<CalendarRequested>(_onCalendarRequested);
    on<CalendarAttendanceUpdate>(_onCalenderAttendanceUpdate);
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
    on<CalendarUpdateTagName>(_onCalendarUpdateTagName);
    on<CalenderUpdateFavorite>(_onCalendarUpdateFavorite);
    on<CalenderExplanationsCompleted>(_onCalendarExplanationsCompleted);
  }

  final CalendarRepository _calendarRepository;

  FutureOr<void> _onCalendarRefresh(
    CalendarRefresh event,
    Emitter<CalendarState> emit,
  ) async {
    final user = await _calendarRepository.fetchCurrentUser();
    if (user != state.user) {
      emit(state.copyWith(user: user));
      add(const CalendarTagFilterUpdate());
      add(CalendarRequested());
    }
  }

  FutureOr<void> _onCalendarRequested(
    CalendarRequested event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: CalendarStatus.loading));

    final user = await _calendarRepository.fetchCurrentUser();
    if (user == null) {
      emit(state.copyWith(status: CalendarStatus.failure));
      return;
    }

    emit(state.copyWith(user: user));

    final weeks = await _calendarRepository.fetchCalendar(user: user);
    final tags = await _calendarRepository.fetchTags();

    emit(
      state.copyWith(
        status: CalendarStatus.success,
        weeks: weeks,
        tags: tags,
        user: user,
      ),
    );
  }

  FutureOr<void> _onCalenderAttendanceUpdate(
    CalendarAttendanceUpdate event,
    Emitter<CalendarState> emit,
  ) async {
    final update = await _calendarRepository.updateAttendanceAt(
      date: event.date,
      isAttending: event.isAttending,
      weeks: state.weeks,
    );

    emit(state.copyWith(weeks: update.weeks, user: update.user));
  }

  FutureOr<void> _onCalendarSearchTextUpdate(
    CalendarSearchTextUpdate event,
    Emitter<CalendarState> emit,
  ) {
    final filter = state.filter.copyWith(search: event.searchText);

    emit(state.copyWith(filter: filter));
  }

  FutureOr<void> _onCalendarTagFilterUpdate(
    CalendarTagFilterUpdate event,
    Emitter<CalendarState> emit,
  ) {
    final filter = state.filter.copyWith(tags: event.tags);

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

    final update = await _calendarRepository.addTagToUser(
      weeks: state.weeks,
      tagName: event.tagName,
      userId: event.userId,
    );

    emit(
      state.copyWith(
        weeks: update.weeks,
        tags: {...state.tags, event.tagName}.toList(),
        user: update.user,
      ),
    );
  }

  FutureOr<void> _onCalendarRemoveTag(
    CalendarRemoveTag event,
    Emitter<CalendarState> emit,
  ) async {
    final update = await _calendarRepository.removeTagFromUser(
      weeks: state.weeks,
      tag: event.tagName,
      userId: event.userId,
    );

    emit(state.copyWith(weeks: update.weeks, user: update.user));
  }

  FutureOr<void> _onCalendarUpdateTagName(
    CalendarUpdateTagName event,
    Emitter<CalendarState> emit,
  ) async {
    final oldTagName = event.tagName;
    final newTagName = event.newTagName;

    final update = await _calendarRepository.updateTagName(
      weeks: state.weeks,
      tagName: oldTagName,
      newTagName: newTagName,
    );

    var filter = state.filter;
    if (filter.tags.contains(oldTagName)) {
      filter = filter.copyWith(
        tags: [...filter.tags.where((tag) => tag != oldTagName), newTagName],
      );
    }

    emit(
      state.copyWith(
        weeks: update.weeks,
        tags: [...state.tags.where((tag) => tag != oldTagName), newTagName],
        filter: filter,
        user: update.user,
      ),
    );
  }

  FutureOr<void> _onCalendarUpdateFavorite(
    CalenderUpdateFavorite event,
    Emitter<CalendarState> emit,
  ) async {
    final update = await _calendarRepository.updateFavorite(
      userId: event.userId,
      isFavorite: event.isFavorite,
      weeks: state.weeks,
    );

    emit(state.copyWith(weeks: update.weeks, user: update.user));
  }

  Future<void> _onCalendarExplanationsCompleted(
    CalenderExplanationsCompleted event,
    Emitter<CalendarState> emit,
  ) async {
    final updatedUser = await _calendarRepository.completeExplanations();
    emit(state.copyWith(user: updatedUser));
  }
}
