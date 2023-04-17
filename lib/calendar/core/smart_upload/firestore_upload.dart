import 'package:collection/collection.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/model/model.dart';

class FirestoreUpload {
  FirestoreUpload({
    required User currentUser,
    required List<Attendance> updatedAttendances,
    required FirestoreRepository firestoreRepository,
  })  : _currentUser = currentUser,
        _updatedAttendances = updatedAttendances,
        _firestoreRepository = firestoreRepository;

  final User _currentUser;
  final List<Attendance> _updatedAttendances;
  final FirestoreRepository _firestoreRepository;

  Future<void> call() async {
    final userAttendances = _updatedAttendances.where((a) {
      return a.present.contains(Entry(userId: _currentUser.id)) ||
          a.absent.contains(Entry(userId: _currentUser.id));
    });

    for (final attendance in userAttendances) {
      final presentEntry = attendance.present
          .firstWhereOrNull((e) => e.userId == _currentUser.id);
      final absentEntry = attendance.absent
          .firstWhereOrNull((e) => e.userId == _currentUser.id);

      if (presentEntry != null) {
        await _firestoreRepository.updateAttendanceAt(
          date: attendance.date,
          isAttending: true,
          reason: presentEntry.reason,
        );
      } else if (absentEntry != null) {
        await _firestoreRepository.updateAttendanceAt(
          date: attendance.date,
          isAttending: false,
          reason: absentEntry.reason,
          isHoliday: absentEntry.isHoliday,
        );
      }
    }

    // final oldDates = _oldAttendances
    //     .whereUserId(_currentUser.id)
    //     .map((attendance) => attendance.date)
    //     .toSet();

    // final updatedDates = _updatedAttendances
    //     .whereUserId(_currentUser.id)
    //     .map((attendance) => attendance.date)
    //     .toSet();

    // final datesToRemove = oldDates.difference(updatedDates);
    // final datesToAdd = updatedDates.difference(oldDates);

    // for (final date in datesToRemove) {
    //   await _firestoreRepository.updateAttendanceAt(
    //     date: date,
    //     isAttending: false,
    //   );
    // }

    // for (final date in datesToAdd) {
    //   await _firestoreRepository.updateAttendanceAt(
    //     date: date,
    //     isAttending: true,
    //   );
    // }
  }
}
