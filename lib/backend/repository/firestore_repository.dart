import 'package:jambu/backend/datasource/datasource.dart';
import 'package:jambu/backend/repository/user_repository.dart';
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

  Future<List<Attendance>> getAttendances() async {
    return _firestoreDatasource.getAttendances();
  }

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
    String? reason,
  }) async {
    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return;

    await _firestoreDatasource.updateAttendanceAt(
      date: date,
      isAttending: isAttending,
      user: currentUser,
      reason: reason,
    );
  }

  Future<void> addManualAbsence(DateTime date) async {
    final user = _userRepository.currentUser;
    if (user == null) return;

    await _firestoreDatasource.updateManualAbsences(
      date: date,
      userId: user.id,
      add: true,
    );
  }

  Future<void> removeManualAbsence(DateTime date) async {
    final user = _userRepository.currentUser;
    if (user == null) return;

    await _firestoreDatasource.updateManualAbsences(
      date: date,
      userId: user.id,
      add: false,
    );
  }

  Future<void> createTag({
    required String name,
    required String currentUserId,
    required String tagUserId,
  }) async {
    return _firestoreDatasource.createTag(
      name: name,
      currentUserId: currentUserId,
      tagUserId: tagUserId,
    );
  }
}
