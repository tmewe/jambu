import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:jambu/constants.dart';
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
    final day = DateTime(date.year, date.month, date.day);
    final formattedDate = DateFormat('yyyy-MM-dd').format(day);

    final attendanceRef = _firestore
        .collection(Constants.attendancesCollection)
        .doc(formattedDate);

    final entry = Entry(userId: user.id, reason: reason);
    try {
      // Try to update an existing attendance
      // If there is none we continue in the catch block
      final entryMap = entry.toMap();
      final presentFieldValue = isAttending
          ? FieldValue.arrayUnion([entryMap])
          : FieldValue.arrayRemove([entryMap]);

      final absensceFieldValue = isAttending
          ? FieldValue.arrayRemove([entryMap])
          : FieldValue.arrayUnion([entryMap]);

      await attendanceRef.update({
        Constants.presentField: presentFieldValue,
        Constants.absentField: absensceFieldValue
      });
    } catch (_) {
      // No document found for the given date -> create a new one
      final attendance = Attendance(
        date: day,
        present: isAttending ? [entry] : [],
        absent: !isAttending ? [entry] : [],
      );
      await attendanceRef.set(attendance.toFirestore());
    }
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
