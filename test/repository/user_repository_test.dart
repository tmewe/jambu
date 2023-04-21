// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreDatasource extends Mock implements FirestoreDatasource {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockMSGraphRepository extends Mock implements MSGraphRepository {}

class MockPhotoStorageRepository extends Mock
    implements PhotoStorageRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('UserRepository', () {
    late User user;
    late UserRepository userRepository;
    late FirestoreDatasource firestoreDatasource;

    setUp(() {
      final authRepository = MockAuthRepository();

      when(() => authRepository.userStream)
          .thenAnswer((_) => const Stream.empty());

      firestoreDatasource = MockFirestoreDatasource();

      userRepository = UserRepository(
        firestoreDatasource: firestoreDatasource,
        authRepository: authRepository,
        msGraphRepository: MockMSGraphRepository(),
        photoStorageRepository: MockPhotoStorageRepository(),
      );

      user = User(id: '0', name: 'Test User', email: 'test@user.de');
    });

    group('updateRegularAttendances', () {
      setUp(() {
        when(
          () => firestoreDatasource.updateRegularAttendances(
            userId: any(named: 'userId'),
            weekdays: any(named: 'weekdays'),
          ),
        ).thenAnswer((_) async => null);
      });

      test('returns null when user is null', () async {
        // arrange
        userRepository.updateUser(null);

        // act
        final result = await userRepository.updateRegularAttendances([]);

        // assert
        expect(result, isNull);
      });

      test(
          'updateRegularAttendances gets called once '
          'when user is not null', () async {
        // arrange
        userRepository.updateUser(user);

        // act
        await userRepository.updateRegularAttendances([]);

        // assert
        verify(
          () => firestoreDatasource.updateRegularAttendances(
            userId: any(named: 'userId'),
            weekdays: any(named: 'weekdays'),
          ),
        ).called(1);
      });
    });
  });
}
