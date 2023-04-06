import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:jambu/backend/datasource/datasource.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';
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
        _currentUserSubject.add(null);
        _authStateSubject.add(AuthenticationState.loggedOut);
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
  final BehaviorSubject<AuthenticationState> _authStateSubject =
      BehaviorSubject.seeded(AuthenticationState.undefiend);

  Stream<User?> get currentUserStream => _currentUserSubject.stream;

  Stream<AuthenticationState> get authStateStream => _authStateSubject.stream;

  User? get currentUser => _currentUserSubject.value;

  Future<User?> fetchCurrentUser() async {
    if (currentUser == null) return null;
    final users = await _firestoreDatasource.getUsers();
    final fetchedUser = users.firstWhereOrNull((u) => u.id == currentUser!.id);
    _currentUserSubject.add(fetchedUser);
    _authStateSubject.add(AuthenticationState.loggedIn);
    return fetchedUser;
  }

  /// Syncs the firebase auth user with the user from firestore
  Future<void> updateUserFromFirebase(fb_auth.User firebaseUser) async {
    final users = await _firestoreDatasource.getUsers();
    final currentUser = users.firstWhereOrNull(
      (user) => user.id == firebaseUser.uid,
    );

    if (currentUser != null) {
      _currentUserSubject.add(currentUser);
      _authStateSubject.add(AuthenticationState.loggedIn);
      return;
    }

    final msUser = await _msGraphRepository.me();
    final name = firebaseUser.displayName;
    final msPhoto = await _msGraphRepository.profilePhoto();

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
    _currentUserSubject.add(newUser);
    _authStateSubject.add(AuthenticationState.loggedIn);
  }

  Future<void> addManualAbsence(DateTime date) async {
    final user = currentUser;
    if (user == null) return;

    await _firestoreDatasource.updateManualAbsences(
      date: date,
      userId: user.id,
      add: true,
    );
  }

  Future<void> removeManualAbsence(DateTime date) async {
    final user = currentUser;
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
    final user = currentUser;
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
    final user = currentUser;
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

  Future<void> completeOnboarding({
    required List<int> regularAttendances,
  }) async {
    final user = currentUser;
    if (user == null) return;
    await updateRegularAttendances(regularAttendances);
    await _firestoreDatasource.completeOnboarding(userId: user.id);
    _currentUserSubject.add(
      currentUser?.copyWith(onboardingCompleted: true),
    );
  }

  Future<void> updateRegularAttendances(List<int> weekdays) async {
    final user = currentUser;
    if (user == null) return;
    await _firestoreDatasource.updateRegularAttendances(
      userId: user.id,
      weekdays: weekdays,
    );
  }
}
