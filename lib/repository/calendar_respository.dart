import 'dart:async';

import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/repository/repository.dart';

// TODO(tim): Add tests
class CalendarRepository {
  CalendarRepository({
    required FirestoreRepository firestoreRepository,
    required UserRepository userRepository,
    required MSGraphRepository msGraphRepository,
  })  : _firestoreRepository = firestoreRepository,
        _userRepository = userRepository,
        _msGraphRepository = msGraphRepository;

  final FirestoreRepository _firestoreRepository;
  final UserRepository _userRepository;
  final MSGraphRepository _msGraphRepository;

  Future<List<CalendarWeek>> fetchCalendar({
    CalendarFilter filter = const CalendarFilter(),
  }) async {
    final currentUser = await _userRepository.fetchCurrentUser();
    if (currentUser == null) return [];

    final attendances = await SmartSync(
      currentUser: currentUser,
      firestoreRepository: _firestoreRepository,
      msGraphRepository: _msGraphRepository,
    )();

    final users = await _firestoreRepository.getUsers();

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
    final updatedDay = day.copyWithoutReason(isUserAttending: isAttending);
    final updatedWeeks = weeks.updateDay(updatedDay);

    unawaited(
      _firestoreRepository.updateAttendanceAt(
        date: date,
        isAttending: isAttending,
      ),
    );

    unawaited(
      _msGraphRepository.updateAttendanceAt(
        date: date,
        isAttending: isAttending,
      ),
    );

    if (isAttending) {
      unawaited(_firestoreRepository.removeManualAbsence(date));
    } else {
      unawaited(_firestoreRepository.addManualAbsence(date));
    }

    return updatedWeeks;
  }
}
