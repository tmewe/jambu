// ignore_for_file: cascade_invocations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/repository/repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAuthProvider extends Mock implements MicrosoftAuthProvider {}

void main() {
  final firebaseAuth = MockFirebaseAuth();

  setUpAll(
    () {
      when(firebaseAuth.authStateChanges).thenAnswer(
        (_) => Stream<User?>.value(null),
      );

      registerFallbackValue(MockAuthProvider());
    },
  );

  group('login', () {
    test('signInWithPopup() is called once if web', () async {
      // arrange
      const isWeb = true;
      when(() => firebaseAuth.signInWithPopup(any())).thenAnswer(
        (_) async => MockUserCredential(),
      );

      final sut = UserRepository(firebaseAuth: firebaseAuth, isWeb: isWeb);

      // act
      await sut.login();

      // assert
      verify(() => firebaseAuth.signInWithPopup(any())).called(1);
    });

    test('signInWithProvider() is called once if not web', () async {
      // arrange
      const isWeb = false;
      when(() => firebaseAuth.signInWithProvider(any())).thenAnswer(
        (_) async => MockUserCredential(),
      );

      final sut = UserRepository(firebaseAuth: firebaseAuth, isWeb: isWeb);

      // act
      await sut.login();

      // assert
      verify(() => firebaseAuth.signInWithProvider(any())).called(1);
    });
  });
}
