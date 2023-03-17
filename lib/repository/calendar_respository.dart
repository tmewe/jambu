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

  List<CalendarWeek> weeks = [];

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

    this.weeks = weeks;

    final filteredWeeks = CalendarFiltering(
      filter: filter,
      weeks: weeks,
    )();

    return filteredWeeks;
  }

  Future<List<CalendarWeek>> updateFilter(CalendarFilter filter) async {
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

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
  }) async {
    await _firestoreRepository.updateAttendanceAt(
      date: date,
      isAttending: isAttending,
    );
  }
}
