import 'dart:async';

import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/calendar/model/model.dart';

// TODO(tim): Add tests
class CalendarRepository {
  CalendarRepository({
    required FirestoreRepository firestoreRepository,
    required UserRepository userRepository,
  })  : _firestoreRepository = firestoreRepository,
        _userRepository = userRepository;

  final FirestoreRepository _firestoreRepository;
  final UserRepository _userRepository;

  Future<List<CalendarWeek>> fetchCalendar({
    CalendarFilter filter = const CalendarFilter(),
  }) async {
    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return [];

    final users = await _firestoreRepository.getUsers();
    final attendances = await _firestoreRepository.getAttendances();

    final weeks = CalendarMapping(
      currentUser: currentUser,
      attendances: attendances,
      users: users,
    )();

    return weeks;
  }

  List<CalendarWeek> updateFilter({
    required CalendarFilter filter,
    required List<CalendarWeek> weeks,
  }) {
    return CalendarFiltering(filter: filter, weeks: weeks)();
  }

  Future<List<CalendarWeek>> updateFavorite({
    required String userId,
    required bool isFavorite,
  }) async {
    return [];
  }

  Future<List<CalendarWeek>> addTag({
    required String tag,
    required String userId,
  }) async {
    return [];
  }

  Future<List<CalendarWeek>> removeTag({
    required String tag,
  }) async {
    return [];
  }

  List<CalendarWeek> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
    required List<CalendarWeek> weeks,
    required CalendarFilter filter,
  }) {
    final day = weeks.dayAtDate(date);
    if (day == null) {
      return [];
    }
    final updatedDay = day.copyWith(isUserAttending: isAttending);
    final updatedWeeks = weeks.updateDay(updatedDay);

    unawaited(
      _firestoreRepository.updateAttendanceAt(
        date: date,
        isAttending: isAttending,
      ),
    );

    return updatedWeeks;
  }
}
