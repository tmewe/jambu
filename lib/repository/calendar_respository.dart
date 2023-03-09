import 'package:jambu/backend/backend.dart';
import 'package:jambu/model/model.dart';

// TODO(tim): Add tests
class CalendarRepository {
  CalendarRepository({
    required FirestoreRepository firestoreRepository,
    required UserRepository userRepository,
  })  : _firestoreRepository = firestoreRepository,
        _userRepository = userRepository;

  final FirestoreRepository _firestoreRepository;
  final UserRepository _userRepository;

  List<Attendance> allAttendances = [];
  List<Attendance> otherAttendances = [];
  List<DateTime> userAttendances = [];

  Future<List<Attendance>> getAttendances() async {
    allAttendances = await _firestoreRepository.getAttendances();

    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return [];

    // Filter out current user
    final filteredAttendances = allAttendances.map((a) {
      return a.copyWith(
        users: a.users.where((uid) => uid != currentUser.id).toList(),
      );
    }).toList();

    otherAttendances = filteredAttendances;
    return filteredAttendances;
  }

  Future<List<DateTime>> getAttendancesForUser() async {
    if (allAttendances.isEmpty) {
      allAttendances = await _firestoreRepository.getAttendances();
    }

    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return [];

    final filteredAttendances = allAttendances
        .where((a) => a.users.contains(currentUser.id))
        .map((a) => a.date)
        .toList();

    userAttendances = filteredAttendances;
    return filteredAttendances;
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
