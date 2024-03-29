import 'dart:async';

import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/calendar/core/favorites/favorites.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/holidays/holidays.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';
import 'package:jambu/user/user.dart';

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
      holidaysRepository: _holidaysRepository,
    )();

    final users = await _firestoreRepository.getUsers();

    final weeks = CalendarMapping(
      currentUser: user,
      attendances: attendances,
      users: users,
    )();

    final calendars = await _msGraphRepository.fetchCalendars();

    unawaited(
      TagsOutlookSync(
        calendars: calendars,
        msGraphRepository: _msGraphRepository,
        attendances: weeks,
        tagNames: user.tags.map((t) => t.name),
      )(),
    );

    unawaited(
      FavoritesOutlookSync(
        calendars: calendars,
        msGraphRepository: _msGraphRepository,
        attendances: weeks,
        favoriteUserIds: user.favorites,
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

    final calendars = await _msGraphRepository.fetchCalendars();

    unawaited(
      TagsOutlookSync(
        calendars: calendars,
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

    final calendars = await _msGraphRepository.fetchCalendars();

    unawaited(
      TagsOutlookSync(
        calendars: calendars,
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

    unawaited(
      _msGraphRepository.updateCalendarName(
        calendarName: tagName.calendarName,
        newCalendarName: newTagName.calendarName,
      ),
    );

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

    final calendars = await _msGraphRepository.fetchCalendars();

    unawaited(
      FavoritesOutlookSync(
        calendars: calendars,
        msGraphRepository: _msGraphRepository,
        attendances: updatedWeeks,
        favoriteUserIds: updatedUser?.favorites ?? [],
      )(),
    );

    return CalendarUpdate(weeks: updatedWeeks, user: updatedUser);
  }

  Future<User?> completeExplanations() {
    return _userRepository.completeExplanations();
  }
}
