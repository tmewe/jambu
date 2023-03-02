// ignore_for_file: cascade_invocations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/repository/repository.dart';
import 'package:jambu/storage/storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockAuthProvider extends Mock implements MicrosoftAuthProvider {}

class MockUser extends Mock implements User {}

void main() {
  final firebaseAuth = MockFirebaseAuth();
  final tokenStorage = InMemoryTokenStorage();

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

      final sut = UserRepository(
        firebaseAuth: firebaseAuth,
        tokenStorage: tokenStorage,
        isWeb: isWeb,
      );

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

      final sut = UserRepository(
        firebaseAuth: firebaseAuth,
        tokenStorage: tokenStorage,
        isWeb: isWeb,
      );

      // act
      await sut.login();

      // assert
      verify(() => firebaseAuth.signInWithProvider(any())).called(1);
    });

    test('tokens get saved', () async {
      // arrange
      final sut = UserRepository(
        firebaseAuth: firebaseAuth,
        tokenStorage: tokenStorage,
        isWeb: true,
      );

      const accessToken = 'access_token';
      const refreshToken = 'refresh_token';

      final authCredential = MockAuthCredential();
      when(() => authCredential.accessToken).thenReturn(accessToken);

      final user = MockUser();
      when(() => user.refreshToken).thenReturn(refreshToken);

      final userCredential = MockUserCredential();
      when(() => userCredential.credential).thenReturn(authCredential);
      when(() => userCredential.user).thenReturn(user);

      when(() => firebaseAuth.signInWithPopup(any())).thenAnswer(
        (_) async => userCredential,
      );

      // act
      await sut.login();

      // assert
      expect(tokenStorage.readAccessToken(), accessToken);
      expect(tokenStorage.readRefreshToken(), refreshToken);
    });
  });
}
