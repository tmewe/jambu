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

      user = const User(id: '0', name: 'Test User', email: 'test@user.de');

      registerFallbackValue(user);
    });

    group('updateRegularAttendances', () {
      setUp(() {
        when(
          () => firestoreDatasource.updateRegularAttendances(
            userId: any(named: 'userId'),
            weekdays: any(named: 'weekdays'),
          ),
        ).thenAnswer((_) async => null);

        when(
          () => firestoreDatasource.removeAttendances(
            dates: any(named: 'dates'),
            user: any(named: 'user'),
          ),
        ).thenAnswer((_) async {});
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

      test(
          'removeAttendances gets never called '
          'when user does not remove regular attendances', () async {
        // arrange
        userRepository.updateUser(user.copyWith(regularAttendances: [1, 2]));

        // act
        await userRepository.updateRegularAttendances([1, 2, 3]);

        // assert
        verifyNever(
          () => firestoreDatasource.removeAttendances(
            dates: any(named: 'dates'),
            user: any(named: 'user'),
          ),
        );
      });

      test(
          'removeAttendances gets called once '
          'when user removes regular attendances', () async {
        // arrange
        userRepository.updateUser(user.copyWith(regularAttendances: [1, 2]));

        // act
        await userRepository.updateRegularAttendances([2]);

        // assert
        verify(
          () => firestoreDatasource.removeAttendances(
            dates: any(named: 'dates'),
            user: any(named: 'user'),
          ),
        ).called(1);
      });
    });

    group('datesFromWeekdays', () {
      final today = DateTime.parse('2023-04-21');

      test('returns empty list when weekdays is empty', () {
        // act
        final result = userRepository.datesFromWeekdays(
          weekdays: [],
          today: today,
        );

        // assert
        expect(result, isEmpty);
      });

      test('returns four times as many elements as weekdays length', () {
        // arrange
        final inputs = [
          [1],
          [1, 2],
          [1, 2, 3],
          [1, 2, 3, 4],
          [1, 2, 3, 4, 5],
        ];

        // act
        for (final input in inputs) {
          final result = userRepository.datesFromWeekdays(
            weekdays: input,
            today: today,
          );

          // assert
          expect(result, hasLength(input.length * 4));
        }
      });

      test('returns correct dates', () {
        // arrange
        final weekdays = [2];
        final expectedResult = [
          DateTime.parse('2023-04-18'),
          DateTime.parse('2023-04-25'),
          DateTime.parse('2023-05-02'),
          DateTime.parse('2023-05-09'),
        ];

        // act
        final result = userRepository.datesFromWeekdays(
          weekdays: weekdays,
          today: today,
        );

        // assert
        expect(result, expectedResult);
      });
    });
  });
}
