import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginRepository {
  LoginRepository({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  Future<UserCredential> login() async {
    final msProvider = MicrosoftAuthProvider()
      ..addScope('profile')
      ..addScope('user.read')
      ..addScope('user.readwrite')
      ..setCustomParameters(
        {'tenant': 'e6dbe219-77ef-4b6a-af83-f9de7de08923'},
      );
    if (kIsWeb) {
      return FirebaseAuth.instance.signInWithPopup(msProvider);
    } else {
      return FirebaseAuth.instance.signInWithProvider(msProvider);
    }
  }
}
