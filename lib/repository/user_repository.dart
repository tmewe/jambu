import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

class UserRepository {
  UserRepository({
    required FirebaseAuth firebaseAuth,
    bool isWeb = kIsWeb,
  })  : _firebaseAuth = firebaseAuth,
        _isWeb = isWeb {
    _firebaseAuth.authStateChanges().listen((user) {
      log('User changed: ${user?.displayName}');
      _userSubject.add(user);
    });
  }

  final FirebaseAuth _firebaseAuth;
  final bool _isWeb;

  final BehaviorSubject<User?> _userSubject = BehaviorSubject.seeded(null);

  Stream<User?> get userStream => _userSubject.stream;

  /// Login using ms azure
  Future<UserCredential> login() async {
    final msProvider = MicrosoftAuthProvider()
      ..addScope('profile')
      ..addScope('user.read')
      ..addScope('user.readwrite')
      ..setCustomParameters(
        {'tenant': 'e6dbe219-77ef-4b6a-af83-f9de7de08923'},
      );
    if (_isWeb) {
      return _firebaseAuth.signInWithPopup(msProvider);
    } else {
      return _firebaseAuth.signInWithProvider(msProvider);
    }
  }
}
