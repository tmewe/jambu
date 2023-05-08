import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:jambu/backend/backend.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';
import 'package:jambu/photo_storage/photo_storage.dart';
import 'package:jambu/user/user.dart';
import 'package:rxdart/subjects.dart';

enum AuthenticationState {
  undefiend,
  loggedIn,
  loggedOut;
}

class UserRepository {
  UserRepository({
    required FirestoreDatasource firestoreDatasource,
    required AuthRepository authRepository,
    required MSGraphRepository msGraphRepository,
    required PhotoStorageRepository photoStorageRepository,
  })  : _firestoreDatasource = firestoreDatasource,
        _authRepository = authRepository,
        _msGraphRepository = msGraphRepository,
        _photoStorageRepository = photoStorageRepository {
    _authRepository.userStream.skip(1).listen((fb_auth.User? firebaseUser) {
      if (firebaseUser == null) {
        updateUser(null);
        return;
      }
      updateUserFromFirebase(firebaseUser);
    });
  }

  final FirestoreDatasource _firestoreDatasource;
  final AuthRepository _authRepository;
  final MSGraphRepository _msGraphRepository;
  final PhotoStorageRepository _photoStorageRepository;

  final BehaviorSubject<User?> _currentUserSubject =
      BehaviorSubject.seeded(null);

  Stream<User?> get currentUserStream => _currentUserSubject.stream;

  User? get currentUser => _currentUserSubject.value;

  Future<User?> fetchCurrentUser() async {
    if (currentUser == null) return null;
    final users = await _firestoreDatasource.getUsers();
    final fetchedUser = users.firstWhereOrNull((u) => u.id == currentUser!.id);
    updateUser(fetchedUser);
    return fetchedUser;
  }

  /// Syncs the firebase auth user with the user from firestore
  Future<void> updateUserFromFirebase(fb_auth.User firebaseUser) async {
    final users = await _firestoreDatasource.getUsers();
    final currentUser = users.firstWhereOrNull(
      (user) => user.id == firebaseUser.uid,
    );

    if (currentUser != null) {
      updateUser(currentUser);
      return;
    }

    final msUser = await _msGraphRepository.me();
    final name = firebaseUser.displayName;
    final msPhoto = await _msGraphRepository.fetchProfilePhoto();

    String? photoUrl;
    if (msPhoto != null && name != null) {
      photoUrl = await _photoStorageRepository.uploadPhotoData(
        data: msPhoto,
        userName: name,
      );
    }
    final newUser = User(
      id: firebaseUser.uid,
      name: name ?? '-',
      email: firebaseUser.email ?? '-',
      jobTitle: msUser?.jobTitle,
      imageUrl: photoUrl,
    );

    await _firestoreDatasource.updateUser(newUser);
    updateUser(newUser);
  }

  Future<User?> addManualAbsence(DateTime date) async {
    final user = currentUser;
    if (user == null) return null;

    final updatedUser = await _firestoreDatasource.updateManualAbsences(
      date: date,
      userId: user.id,
      add: true,
    );

    updateUser(updatedUser);
    return updatedUser;
  }

  Future<User?> removeManualAbsence(DateTime date) async {
    final user = currentUser;
    if (user == null) return null;

    final updatedUser = await _firestoreDatasource.updateManualAbsences(
      date: date,
      userId: user.id,
      add: false,
    );

    updateUser(updatedUser);
    return updatedUser;
  }

  Future<User?> addTagToUser({
    required String tagName,
    required String currentUserId,
    required String tagUserId,
  }) async {
    final updatedUser = await _firestoreDatasource.addTagToUser(
      tagName: tagName,
      currentUserId: currentUserId,
      tagUserId: tagUserId,
    );

    updateUser(updatedUser);
    return updatedUser;
  }

  Future<User?> removeTagFromUser({
    required String tagName,
    required String currentUserId,
    required String tagUserId,
  }) async {
    final updatedUser = await _firestoreDatasource.removeTagFromUser(
      tagName: tagName,
      currentUserId: currentUserId,
      tagUserId: tagUserId,
    );

    _currentUserSubject.add(updatedUser);
    return updatedUser;
  }

  Future<User?> deleteTag({required String tagName}) async {
    final user = currentUser;
    if (user == null) return null;

    final updatedUser = await _firestoreDatasource.deleteTag(
      tagName: tagName,
      currentUserId: user.id,
    );

    unawaited(_msGraphRepository.deleteCalendar(name: tagName.calendarName));

    updateUser(updatedUser);
    return updatedUser;
  }

  Future<User?> updateTagName({
    required String tagName,
    required String newTagName,
  }) async {
    final user = currentUser;
    if (user == null) return null;

    final updatedUser = await _firestoreDatasource.updateTagName(
      tagName: tagName,
      newTagName: newTagName,
      userId: user.id,
    );

    updateUser(updatedUser);
    return updatedUser;
  }

  Future<User?> updateFavorite({
    required String userId,
    required bool isFavorite,
  }) async {
    final user = currentUser;
    if (user == null) return null;

    final updatedUser = _firestoreDatasource.updateFavorite(
      currentUserId: user.id,
      favoriteUserId: userId,
      isFavorite: isFavorite,
    );
    return updatedUser;
  }

  Future<void> completeOnboarding({
    required List<int> regularAttendances,
  }) async {
    final user = currentUser;
    if (user == null) return;
    await updateRegularAttendances(regularAttendances);
    await _firestoreDatasource.completeOnboarding(userId: user.id);

    updateUser(
      currentUser?.copyWith(onboardingCompleted: true),
    );
  }

  Future<User?> completeExplanations() async {
    final user = currentUser;
    if (user == null) return null;

    await _firestoreDatasource.completeExplanations(userId: user.id);
    final updatedUser = currentUser?.copyWith(explanationsCompleted: true);
    updateUser(updatedUser);
    return updatedUser;
  }

  Future<User?> updateRegularAttendances(List<int> weekdays) async {
    final user = currentUser;
    if (user == null) return null;

    final updatedUser = await _firestoreDatasource.updateRegularAttendances(
      userId: user.id,
      weekdays: weekdays,
    );

    final daysToRemove = user.regularAttendances.toSet().difference(
          weekdays.toSet(),
        );

    if (daysToRemove.isNotEmpty) {
      final datesToRemove = datesFromWeekdays(
        weekdays: daysToRemove.toList(),
        today: DateTime.now(),
      );
      await _firestoreDatasource.removeAttendances(
        dates: datesToRemove,
        user: user,
      );
    }

    updateUser(updatedUser);
    return updatedUser;
  }

  Future<User?> updateColorBlindness({required bool isColorBlind}) async {
    final user = currentUser;
    if (user == null) return null;

    final updatedUser = _firestoreDatasource.updateColorBlindness(
      isColorBlind: isColorBlind,
      user: user,
    );

    return updatedUser;
  }

  List<DateTime> datesFromWeekdays({
    required List<int> weekdays,
    required DateTime today,
  }) {
    return weekdays
        .map((day) {
          final firstDate =
              today.firstDateOfWeek.add(Duration(days: day - 1)).midnight;
          return [
            firstDate,
            firstDate.add(const Duration(days: 7)),
            firstDate.add(const Duration(days: 14)),
            firstDate.add(const Duration(days: 21)),
          ];
        })
        .expand((date) => date)
        .toList();
  }

  void updateUser(User? user) {
    _currentUserSubject.add(user);
  }
}
