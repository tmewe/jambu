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

  Future<List<Attendance>> getAttendances() async {
    return _firestoreDatasource.getAttendances();
  }

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
  }) async {
    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return;

    await _firestoreDatasource.updateAttendanceAt(
      date: date,
      isAttending: isAttending,
      user: currentUser,
    );
  }
}
