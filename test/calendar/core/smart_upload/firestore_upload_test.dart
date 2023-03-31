import 'package:flutter_test/flutter_test.dart';
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
        'when updated attendances are empty', () async {
      // arrange
      final upload = FirestoreUpload(
        currentUser: user,
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
        'One attendance update '
        'where isAttendig is false '
        'when attendances contain attendance with an absent element', () async {
      // arrange
      final absentEntry = Entry(userId: user.id);
      final attendance = Attendance(date: date, absent: [absentEntry]);
      final upload = FirestoreUpload(
        currentUser: user,
        updatedAttendances: [attendance],
        firestoreRepository: firestoreRepository,
      );

      // act
      await upload();

      // assert
      verify(
        () => firestoreRepository.updateAttendanceAt(
          date: date,
          isAttending: false,
        ),
      ).called(1);
    });

    test(
        'One attendance update '
        'where isAttendig is true '
        'when attendances contain attendance with an present element',
        () async {
      // arrange
      final presentEntry = Entry(userId: user.id);
      final attendance = Attendance(date: date, present: [presentEntry]);
      final upload = FirestoreUpload(
        currentUser: user,
        updatedAttendances: [attendance],
        firestoreRepository: firestoreRepository,
      );

      // act
      await upload();

      // assert
      verify(
        () => firestoreRepository.updateAttendanceAt(
          date: date,
          isAttending: true,
        ),
      ).called(1);
    });
  });
}
