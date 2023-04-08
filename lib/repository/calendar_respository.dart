import 'dart:async';

import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/calendar/core/tags_outlook_sync/tags_outlook_sync.dart';
import 'package:jambu/calendar/core/update_favorite.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/holidays/repository/repository.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';

class CalendarRepository {
  CalendarRepository({
    required FirestoreRepository firestoreRepository,
    required UserRepository userRepository,
    required MSGraphRepository msGraphRepository,
    required HolidaysRepository holidaysRepository,
  })  : _firestoreRepository = firestoreRepository,
        _userRepository = userRepository,
        _msGraphRepository = msGraphRepository,
        _holidaysRepository = holidaysRepository;

  final FirestoreRepository _firestoreRepository;
  final UserRepository _userRepository;
  final MSGraphRepository _msGraphRepository;
  final HolidaysRepository _holidaysRepository;

  Future<User?> fetchCurrentUser() {
    return _userRepository.fetchCurrentUser();
  }

  Future<List<CalendarWeek>> fetchCalendar({
    required User user,
  }) async {
    final attendances = await SmartSync(
      currentUser: user,
      firestoreRepository: _firestoreRepository,
      msGraphRepository: _msGraphRepository,
    )();

    final users = await _firestoreRepository.getUsers();

    final holidays = await _holidaysRepository.fetchHolidays();

    final weeks = CalendarMapping(
      currentUser: user,
      attendances: attendances,
      users: users,
      holidays: holidays,
    )();

    unawaited(
      TagsOutlookSync(
        msGraphRepository: _msGraphRepository,
        attendances: weeks,
        tagNames: user.tags.map((t) => t.name),
      )(),
    );

    return weeks;
  }

  Future<List<String>> fetchTags() async {
    final user = _userRepository.currentUser;
    return user != null ? user.tags.map((t) => t.name).toList() : [];
  }

  Future<CalendarUpdate> addTagToUser({
    required String tagName,
    required String userId,
    required List<CalendarWeek> weeks,
  }) async {
    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return CalendarUpdate(weeks: weeks);

    final updatedUser = await _userRepository.addTagToUser(
      tagName: tagName,
      currentUserId: currentUser.id,
      tagUserId: userId,
    );

    final updatedWeeks = AddTags(
      tagNames: [tagName],
      userId: userId,
      weeks: weeks,
    )();

    unawaited(
      TagsOutlookSync(
        msGraphRepository: _msGraphRepository,
        attendances: updatedWeeks,
        tagNames: [tagName],
      )(),
    );

    return CalendarUpdate(weeks: updatedWeeks, user: updatedUser);
  }

  Future<CalendarUpdate> removeTagFromUser({
    required String tag,
    required String userId,
    required List<CalendarWeek> weeks,
  }) async {
    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return CalendarUpdate(weeks: weeks);

    final updatedUser = await _userRepository.removeTagFromUser(
      tagName: tag,
      currentUserId: currentUser.id,
      tagUserId: userId,
    );

    final updatedWeeks = RemoveTag(
      tag: tag,
      userId: userId,
      weeks: weeks,
    )();

    unawaited(
      TagsOutlookSync(
        msGraphRepository: _msGraphRepository,
        attendances: updatedWeeks,
        tagNames: [tag],
      )(),
    );

    return CalendarUpdate(weeks: updatedWeeks, user: updatedUser);
  }

  Future<CalendarUpdate> updateTagName({
    required String tagName,
    required String newTagName,
    required List<CalendarWeek> weeks,
  }) async {
    final updatedUser = await _userRepository.updateTagName(
      tagName: tagName,
      newTagName: newTagName,
    );

    final updatedWeeks = UpdateTagName(
      tagName: tagName,
      newTagName: newTagName,
      weeks: weeks,
    )();

    return CalendarUpdate(weeks: updatedWeeks, user: updatedUser);
  }

  Future<CalendarUpdate> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
    required List<CalendarWeek> weeks,
  }) async {
    final day = weeks.dayAtDate(date);
    if (day == null) {
      return CalendarUpdate(weeks: weeks);
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

    final User? updatedUser;
    if (isAttending) {
      updatedUser = await _userRepository.removeManualAbsence(date);
    } else {
      updatedUser = await _userRepository.addManualAbsence(date);
    }

    return CalendarUpdate(weeks: updatedWeeks, user: updatedUser);
  }

  Future<CalendarUpdate> updateFavorite({
    required String userId,
    required bool isFavorite,
    required List<CalendarWeek> weeks,
  }) async {
    final updatedUser = await _userRepository.updateFavorite(
      userId: userId,
      isFavorite: isFavorite,
    );

    final updatedWeeks = UpdateFavorite(
      userId: userId,
      isFavorite: isFavorite,
      weeks: weeks,
    )();

    return CalendarUpdate(weeks: updatedWeeks, user: updatedUser);
  }
}
