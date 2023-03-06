import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jambu/storage/storage.dart';
import 'package:rxdart/subjects.dart';

class UserRepository {
  UserRepository({
    required FirebaseAuth firebaseAuth,
    required TokenStorage tokenStorage,
    bool isWeb = kIsWeb,
  })  : _firebaseAuth = firebaseAuth,
        _tokenStorage = tokenStorage,
        _isWeb = isWeb {
    _firebaseAuth.authStateChanges().listen((user) {
      debugPrint('User changed: ${user?.displayName}');
      _userSubject.add(user);
    });
  }

  final FirebaseAuth _firebaseAuth;
  final TokenStorage _tokenStorage;
  final bool _isWeb;

  final BehaviorSubject<User?> _userSubject = BehaviorSubject.seeded(null);

  Stream<User?> get userStream => _userSubject.stream;

  User? get currentUser => _userSubject.value;

  /// Login using ms azure
  Future<void> login() async {
    final msProvider = MicrosoftAuthProvider()
      ..addScope('profile')
      ..addScope('user.read')
      ..addScope('user.readwrite')
      ..addScope('calendars.read')
      ..addScope('calendars.readwrite')
      ..setCustomParameters(
        {'tenant': 'e6dbe219-77ef-4b6a-af83-f9de7de08923'},
      );

    final UserCredential userCredential;
    if (_isWeb) {
      userCredential = await _firebaseAuth.signInWithPopup(msProvider);
    } else {
      userCredential = await _firebaseAuth.signInWithProvider(msProvider);
    }
    unawaited(_requestNotifications());
    _saveCredential(userCredential);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _tokenStorage.clearTokens();
  }

  void _saveCredential(UserCredential userCredential) {
    final accessToken = userCredential.credential?.accessToken;
    if (accessToken != null) {
      debugPrint(accessToken, wrapWidth: 1024);
      _tokenStorage.saveAccessToken(accessToken);
    }

    final refreshToken = userCredential.user?.refreshToken;
    if (refreshToken != null) {
      _tokenStorage.saveRefreshToken(refreshToken);
    }
  }

  // TODO(tim): Refactor later
  Future<void> _requestNotifications() async {
    final notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();
    final status = notificationSettings.authorizationStatus;

    if (status == AuthorizationStatus.notDetermined) {
      await FirebaseMessaging.instance.requestPermission();
      final fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            '''BDwDEXNpZUq9IJQ60LNTt3At9ctSWMBiEo5BMXzB9X2VojyfM0En84zNMr328DhLhruGVJQPCjo2lTJ3YCZhGoY''',
      );
      debugPrint(fcmToken);
    }
  }
}
