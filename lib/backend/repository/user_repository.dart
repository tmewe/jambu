import 'package:collection/collection.dart';
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
    required PhotoStorageRepository photoStorageRepository,
  })  : _firestoreDatasource = firestoreDatasource,
        _authRepository = authRepository,
        _msGraphRepository = msGraphRepository,
        _photoStorageRepository = photoStorageRepository {
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
  final PhotoStorageRepository _photoStorageRepository;

  final BehaviorSubject<User?> _currentUserSubject =
      BehaviorSubject.seeded(null);

  Stream<User?> get currentUserStream => _currentUserSubject.stream;

  User? get currentUser => _currentUserSubject.value;

  Future<User?> fetchCurrentUser() async {
    if (currentUser == null) return null;
    final users = await _firestoreDatasource.getUsers();
    final fetchedUser = users.firstWhereOrNull((u) => u.id == currentUser!.id);
    _currentUserSubject.add(fetchedUser);
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
  }
}
