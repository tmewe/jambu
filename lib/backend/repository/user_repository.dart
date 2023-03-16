import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:jambu/backend/datasource/datasource.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class UserRepository {
  UserRepository({
    required FirestoreDatasource firestoreDatasource,
    required AuthRepository authRepository,
    required MSGraphRepository msGraphRepository,
  })  : _firestoreDatasource = firestoreDatasource,
        _authRepository = authRepository,
        _msGraphRepository = msGraphRepository {
    _authRepository.userStream.listen((fb_auth.User? firebaseUser) {
      if (firebaseUser == null) {
        _currentUserSubject.add(null);
        return;
      }
      updateUserFromFirebase(firebaseUser);
    });
  }

  final FirestoreDatasource _firestoreDatasource;
  final AuthRepository _authRepository;
  final MSGraphRepository _msGraphRepository;

  final BehaviorSubject<User?> _currentUserSubject =
      BehaviorSubject.seeded(null);

  Stream<User?> get currentUserStream => _currentUserSubject.stream;

  User? get currentUser => _currentUserSubject.value;

  /// Syncs the firebase auth user with the user from firestore
  Future<void> updateUserFromFirebase(fb_auth.User firebaseUser) async {
    final users = await _firestoreDatasource.getUsers();
    final currentUser = users.firstWhere(
      (user) => user.id == firebaseUser.uid,
      orElse: () {
        return User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '-',
          email: firebaseUser.email ?? '-',
        );
      },
    );

    // Get user data from ms graph
    final msUser = await _msGraphRepository.me();
    final msPhoto = await _msGraphRepository.profilePhoto();

    final updatedUser = currentUser.copyWith(
      name: firebaseUser.displayName ?? '',
      jobTitle: msUser?.jobTitle,
    );

    // TODO(tim): Compare users to check if update is needed
    await updateUser(updatedUser);
  }

  Future<void> updateUser(User user) async {
    await _firestoreDatasource.updateUser(user);
    _currentUserSubject.add(user);
  }
}
