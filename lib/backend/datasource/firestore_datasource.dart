import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';

class FirestoreDatasource {
  FirestoreDatasource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<User>> getUsers() async {
    final querySnaphot =
        await _firestore.collection(Constants.usersCollection).get();
    final users = querySnaphot.docs.map(User.fromFirestore);
    return users.toList();
  }

  Future<void> updateUser(User user) async {
    return _firestore
        .collection(Constants.usersCollection)
        .doc(user.id)
        .set(user.toFirestore());
  }

  Future<List<Attendance>> getAttendances() async {
    final querySnaphot =
        await _firestore.collection(Constants.attendancesCollection).get();
    final attendances = querySnaphot.docs.map(Attendance.fromFirestore);
    return attendances.toList();
  }

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
    required User user,
    String? reason,
  }) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date.midnight);

    final attendanceRef = _firestore
        .collection(Constants.attendancesCollection)
        .doc(formattedDate);

    await _firestore.runTransaction((transaction) async {
      final snaphot = await transaction.get(attendanceRef);

      if (snaphot.exists) {
        final attendance = Attendance.fromFirestore(snaphot);

        final present = isAttending
            ? [
                ...attendance.present.where((e) => e.userId != user.id),
                Entry(userId: user.id, reason: reason),
              ]
            : attendance.present.where((element) => element.userId != user.id);

        final absent = !isAttending
            ? [
                ...attendance.absent.where((e) => e.userId != user.id),
                Entry(userId: user.id, reason: reason),
              ]
            : attendance.absent.where((element) => element.userId != user.id);

        final updatedAttendance = attendance.copyWith(
          present: present.toSet().toList(),
          absent: absent.toSet().toList(),
        );
        transaction.update(attendanceRef, updatedAttendance.toFirestore());
      } else {
        final entry = Entry(userId: user.id, reason: reason);
        final attendance = Attendance(
          date: date.midnight,
          present: isAttending ? [entry] : [],
          absent: !isAttending ? [entry] : [],
        );
        transaction.set(attendanceRef, attendance.toFirestore());
      }
    });
  }

  Future<void> updateManualAbsences({
    required DateTime date,
    required String userId,
    required bool add,
  }) async {
    final fieldValue = add
        ? FieldValue.arrayUnion([Timestamp.fromDate(date)])
        : FieldValue.arrayRemove([Timestamp.fromDate(date)]);
    final ref = _firestore.collection(Constants.usersCollection).doc(userId);
    await ref.update({'manualAbsences': fieldValue});
  }
}
