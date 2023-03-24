import 'package:jambu/backend/backend.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';

class FirestoreUpload {
  FirestoreUpload({
    required User currentUser,
    required List<Attendance> oldAttendances,
    required List<Attendance> updatedAttendances,
    required FirestoreRepository firestoreRepository,
  })  : _currentUser = currentUser,
        _oldAttendances = oldAttendances,
        _updatedAttendances = updatedAttendances,
        _firestoreRepository = firestoreRepository;

  final User _currentUser;
  final List<Attendance> _oldAttendances;
  final List<Attendance> _updatedAttendances;
  final FirestoreRepository _firestoreRepository;

  Future<void> call() async {
    final oldDates = _oldAttendances
        .whereUserId(_currentUser.id)
        .map((attendance) => attendance.date)
        .toSet();

    final updatedDates = _updatedAttendances
        .whereUserId(_currentUser.id)
        .map((attendance) => attendance.date)
        .toSet();

    final datesToRemove = oldDates.difference(updatedDates);
    final datesToAdd = updatedDates.difference(oldDates);

    for (final date in datesToRemove) {
      await _firestoreRepository.updateAttendanceAt(
        date: date,
        isAttending: false,
      );
    }

    for (final date in datesToAdd) {
      await _firestoreRepository.updateAttendanceAt(
        date: date,
        isAttending: true,
      );
    }

    // for (final attendance in oldUserAttendances) {
    //   final updatedAttendance = updatedUserAttendances.firstWhereOrNull(
    //     (a) => a.date.isSameDay(attendance.date),
    //   );
    //   if (updatedAttendance == null) {
    //     await _firestoreRepository.updateAttendanceAt(
    //       date: attendance.date,
    //       isAttending: false,
    //     );
    //   }
    // }

    // for (final attendance in updatedUserAttendances) {
    //   final oldAttendance = oldUserAttendances.firstWhereOrNull(
    //     (a) => a.date.isSameDay(attendance.date),
    //   );
    //   if (oldAttendance == null) {
    //     await _firestoreRepository.updateAttendanceAt(
    //       date: attendance.date,
    //       isAttending: true,
    //     );
    //   }
    // }
  }
}
