import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:jambu/backend/datasource/datasource.dart';
import 'package:jambu/model/model.dart';

class FirestoreRepository {
  FirestoreRepository({
    required FirestoreDatasource firestoreDatasource,
  }) : _firestoreDatasource = firestoreDatasource;

  final FirestoreDatasource _firestoreDatasource;
  User? _currentUser;

  /// Syncs the firebase auth user with the user from firestore
  Future<void> updateUser(fb_auth.User firebaseUser) async {
    final users = await _firestoreDatasource.getUsers();
    final currentUser = users.firstWhere(
      (user) => user.id == firebaseUser.uid,
      orElse: () {
        return User(id: firebaseUser.uid, name: firebaseUser.displayName ?? '');
      },
    );
    _currentUser = currentUser;

    // TODO(tim): Compare users to check if update is needed
    final updatedUser =
        currentUser.copyWith(name: firebaseUser.displayName ?? '');
    await _firestoreDatasource.updateUser(updatedUser);
  }

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
  }) async {
    if (_currentUser == null) return;

    await _firestoreDatasource.updateAttendanceAt(
      date: date,
      isAttending: isAttending,
      user: _currentUser!,
    );
  }
}
