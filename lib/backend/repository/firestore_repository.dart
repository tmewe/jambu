import 'package:jambu/backend/datasource/datasource.dart';
import 'package:jambu/backend/repository/user_repository.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';

class FirestoreRepository {
  FirestoreRepository({
    required FirestoreDatasource firestoreDatasource,
    required UserRepository userRepository,
  })  : _firestoreDatasource = firestoreDatasource,
        _userRepository = userRepository;

  final FirestoreDatasource _firestoreDatasource;
  final UserRepository _userRepository;

  Future<List<User>> getUsers() async {
    return _firestoreDatasource.getUsers();
  }

  Future<List<Attendance>> getAttendancesStartingThisWeek() async {
    final firstDateOfWeek = DateTime.now().midnight.firstDateOfWeek;
    return _firestoreDatasource.getAttendancesStarting(firstDateOfWeek);
  }

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
    String? reason,
    bool? isHoliday,
  }) async {
    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return;

    await _firestoreDatasource.updateAttendanceAt(
      date: date,
      isAttending: isAttending,
      user: currentUser,
      reason: reason,
      isHoliday: isHoliday,
    );
  }
}
