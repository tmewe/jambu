// ignore_for_file: cascade_invocations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/repository/repository.dart';
import 'package:jambu/storage/storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockAuthProvider extends Mock implements MicrosoftAuthProvider {}

class MockUser extends Mock implements User {}

class MockNotificationsRepository extends Mock
    implements NotificationsRespository {}


void main() {
  final firebaseAuth = MockFirebaseAuth();
  final tokenStorage = InMemoryTokenStorage();
  final notificationsRespository = MockNotificationsRepository();

  setUpAll(
    () {
      when(firebaseAuth.authStateChanges).thenAnswer(
        (_) => Stream<User?>.value(null),
      );

      when(notificationsRespository.requestNotifications)
          .thenAnswer((_) async {});

      registerFallbackValue(MockAuthProvider());
      registerFallbackValue(MockUser());
    },
  );

  group('login popup', () {
    test('signInWithPopup() is called once if web', () async {
      // arrange
      const isWeb = true;
      when(() => firebaseAuth.signInWithPopup(any())).thenAnswer(
        (_) async => MockUserCredential(),
      );

      final sut = AuthRepository(
        firebaseAuth: firebaseAuth,
        tokenStorage: tokenStorage,
        notificationsRespository: notificationsRespository,
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

      final sut = AuthRepository(
        firebaseAuth: firebaseAuth,
        tokenStorage: tokenStorage,
        notificationsRespository: notificationsRespository,
        isWeb: isWeb,
      );

      // act
      await sut.login();

      // assert
      verify(() => firebaseAuth.signInWithProvider(any())).called(1);
    });
  });

  group('login', () {
    late final AuthRepository sut;
    setUpAll(() {
      sut = AuthRepository(
        firebaseAuth: firebaseAuth,
        tokenStorage: tokenStorage,
        notificationsRespository: notificationsRespository,
        isWeb: true,
      );
    });

    test('access token get saved', () async {
      // arrange
      const accessToken = 'access_token';

      final authCredential = MockAuthCredential();
      when(() => authCredential.accessToken).thenReturn(accessToken);

      final userCredential = MockUserCredential();
      when(() => userCredential.credential).thenReturn(authCredential);

      when(() => firebaseAuth.signInWithPopup(any())).thenAnswer(
        (_) async => userCredential,
      );

      // act
      await sut.login();

      // assert
      expect(tokenStorage.readAccessToken(), accessToken);
    });
  });
}
