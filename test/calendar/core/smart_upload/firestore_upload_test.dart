import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jambu/backend/repository/repository.dart';
import 'package:jambu/calendar/core/smart_upload/firestore_upload.dart';
import 'package:jambu/model/model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreRepository extends Mock implements FirestoreRepository {}

void main() {
  late User user;
  late FirestoreRepository firestoreRepository;
  late DateTime date;

  setUp(() {
    user = const User(id: '0', name: 'Test User', email: 'test@gmail.de');
    firestoreRepository = MockFirestoreRepository();
    date = DateTime.parse('2023-03-20');

    when(
      () => firestoreRepository.updateAttendanceAt(
        date: any(named: 'date'),
        isAttending: any(named: 'isAttending'),
      ),
    ).thenAnswer((_) async {});
  });

  group('FirestoreUpload', () {
    test(
        'No updates '
        'when old and new attendances are empty', () async {
      // arrange
      final upload = FirestoreUpload(
        currentUser: user,
        oldAttendances: [],
        updatedAttendances: [],
        firestoreRepository: firestoreRepository,
      );

      // act
      await upload();

      // assert
      verifyNever(
        () => firestoreRepository.updateAttendanceAt(
          date: any(named: 'date'),
          isAttending: any(named: 'isAttending'),
        ),
      );
    });

    test(
        'Remove attendances '
        'when new attendances is empty', () async {
      // arrange
      final dates = List.generate(
        5,
        (index) => date.add(Duration(days: index)),
      );

      final oldAttendances =
          dates.map((d) => Attendance(date: d, userIds: [user.id])).toList();

      final upload = FirestoreUpload(
        currentUser: user,
        oldAttendances: oldAttendances,
        updatedAttendances: [],
        firestoreRepository: firestoreRepository,
      );

      // act
      await upload();

      // assert
      for (final date in dates) {
        verify(
          () => firestoreRepository.updateAttendanceAt(
            date: date,
            isAttending: false,
          ),
        );
      }
    });

    test(
        'Add attendances '
        'when old attendances is empty', () async {
      // arrange
      final dates = List.generate(
        5,
        (index) => date.add(Duration(days: index)),
      );

      final newAttendances =
          dates.map((d) => Attendance(date: d, userIds: [user.id])).toList();

      final upload = FirestoreUpload(
        currentUser: user,
        oldAttendances: [],
        updatedAttendances: newAttendances,
        firestoreRepository: firestoreRepository,
      );

      // act
      await upload();

      // assert
      for (final date in dates) {
        verify(
          () => firestoreRepository.updateAttendanceAt(
            date: date,
            isAttending: true,
          ),
        );
      }
    });

    test(
        'Remove two attendances and add two attendances '
        'when old attendances contains four items '
        'and new attendances contains four items '
        'and only two items are overlapping', () async {
      // arrange
      const sharedCount = 2;

      final sharedDates = List.generate(
        sharedCount,
        (index) => date.add(Duration(days: index)),
      );

      final oldDates = List.generate(
        2,
        (index) => date.subtract(Duration(days: index + 1)),
      );

      final updatedDates = List.generate(
        2,
        (index) => date.add(Duration(days: index + sharedCount)),
      );

      final oldAttendances =
          oldDates.map((d) => Attendance(date: d, userIds: [user.id]));

      final sharedAttendances = sharedDates
          .map((d) => Attendance(date: d, userIds: [user.id]))
          .toList();

      final updatedAttendances =
          updatedDates.map((d) => Attendance(date: d, userIds: [user.id]));

      final upload = FirestoreUpload(
        currentUser: user,
        oldAttendances: [...oldAttendances, ...sharedAttendances],
        updatedAttendances: [...sharedAttendances, ...updatedAttendances],
        firestoreRepository: firestoreRepository,
      );

      // act
      await upload();

      // assert
      for (final date in oldDates) {
        verify(
          () => firestoreRepository.updateAttendanceAt(
            date: date,
            isAttending: false,
          ),
        );
      }

      for (final date in updatedDates) {
        verify(
          () => firestoreRepository.updateAttendanceAt(
            date: date,
            isAttending: true,
          ),
        );
      }
    });
  });
}
