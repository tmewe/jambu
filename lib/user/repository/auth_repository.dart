import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:jambu/storage/storage.dart';
import 'package:jambu/user/user.dart';
import 'package:rxdart/subjects.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required TokenStorage tokenStorage,
    bool isWeb = kIsWeb,
  })  : _firebaseAuth = firebaseAuth,
        _tokenStorage = tokenStorage,
        _isWeb = isWeb {
    _firebaseAuth.authStateChanges().distinct().listen((user) {
      debugPrint('User changed: ${user?.displayName}');
      _userSubject.add(user);
      final authState = user != null
          ? AuthenticationState.loggedIn
          : AuthenticationState.loggedOut;
      _authStateSubject.add(authState);
    });
  }

  final FirebaseAuth _firebaseAuth;
  final TokenStorage _tokenStorage;
  final bool _isWeb;

  final BehaviorSubject<User?> _userSubject = BehaviorSubject.seeded(null);

  Stream<User?> get userStream => _userSubject.stream;

  final BehaviorSubject<AuthenticationState> _authStateSubject =
      BehaviorSubject.seeded(AuthenticationState.undefiend);

  Stream<AuthenticationState> get authStateStream => _authStateSubject.stream;

  User? get currentUser => _userSubject.value;

  final msProvider = MicrosoftAuthProvider()
    ..addScope('profile')
    ..addScope('user.read')
    ..addScope('user.readwrite')
    ..addScope('calendars.read')
    ..addScope('calendars.readwrite')
    ..setCustomParameters(
      {'tenant': 'e6dbe219-77ef-4b6a-af83-f9de7de08923'},
    );

  /// Login using ms azure
  Future<UserCredential> login() async {
    final UserCredential userCredential;
    if (_isWeb) {
      userCredential = await _firebaseAuth.signInWithPopup(msProvider);
    } else {
      userCredential = await _firebaseAuth.signInWithProvider(msProvider);
    }
    _saveCredential(userCredential);
    return userCredential;
  }

  /// Gets called to obtain a fresh access token
  Future<void> reauthenticate() async {
    final UserCredential userCredential;
    if (_isWeb) {
      userCredential = await _firebaseAuth.signInWithPopup(msProvider);
    } else {
      userCredential = await _firebaseAuth.signInWithProvider(msProvider);
    }
    _saveCredential(userCredential);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _tokenStorage.clearTokens();
  }

  void _saveCredential(UserCredential userCredential) {
    final accessToken = userCredential.credential?.accessToken;
    if (accessToken != null) {
      _tokenStorage.saveAccessToken(accessToken);
    }
  }
}
