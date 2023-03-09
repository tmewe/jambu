import 'package:flutter/foundation.dart';
import 'package:jambu/backend/datasource/datasource.dart';
import 'package:jambu/backend/repository/user_repository.dart';

class FirestoreRepository {
  FirestoreRepository({
    required FirestoreDatasource firestoreDatasource,
    required UserRepository userRepository,
  })  : _firestoreDatasource = firestoreDatasource,
        _userRepository = userRepository;

  final FirestoreDatasource _firestoreDatasource;
  final UserRepository _userRepository;

  Future<void> getAttendances() async {
    final att = await _firestoreDatasource.getAttendances();
    debugPrint('$att');
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
