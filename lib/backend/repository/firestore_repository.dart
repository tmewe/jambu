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

  Future<void> addTagToUser({
    required String tagName,
    required String currentUserId,
    required String tagUserId,
  }) async {
    return _firestoreDatasource.addTagToUser(
      tagName: tagName,
      currentUserId: currentUserId,
      tagUserId: tagUserId,
    );
  }

  Future<void> removeTagFromUser({
    required String tagName,
    required String currentUserId,
    required String tagUserId,
  }) async {
    return _firestoreDatasource.removeTagFromUser(
      tagName: tagName,
      currentUserId: currentUserId,
      tagUserId: tagUserId,
    );
  }

  Future<void> updateTagName({
    required String tagName,
    required String newTagName,
  }) async {
    final user = _userRepository.currentUser;
    if (user == null) return;
    return _firestoreDatasource.updateTagName(
      tagName: tagName,
      newTagName: newTagName,
      userId: user.id,
    );
  }

  Future<void> updateFavorite({
    required String userId,
    required bool isFavorite,
  }) async {
    final user = _userRepository.currentUser;
    if (user == null) return;
    if (isFavorite) {
      return _firestoreDatasource.addFavorite(
        currentUserId: user.id,
        favoriteUserId: userId,
      );
    } else {
      return _firestoreDatasource.removeFavorite(
        currentUserId: user.id,
        favoriteUserId: userId,
      );
    }
  }

  Future<void> completeOnboarding() async {
    final user = _userRepository.currentUser;
    if (user == null) return;
    await _firestoreDatasource.completeOnboarding(userId: user.id);
    _userRepository.completeOnboarding();
  }

  Future<void> updateRegularAttendances(List<int> weekdays) async {
    final user = _userRepository.currentUser;
    if (user == null) return;
    await _firestoreDatasource.updateRegularAttendances(
      userId: user.id,
      weekdays: weekdays,
    );
  }
}
