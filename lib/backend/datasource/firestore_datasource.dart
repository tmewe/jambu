import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:jambu/model/model.dart';

class FirestoreDatasource {
  FirestoreDatasource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<User>> getUsers() async {
    final querySnaphot = await _firestore.collection('users').get();
    final users = querySnaphot.docs.map(User.fromFirestore);
    return users.toList();
  }

  Future<void> updateUser(User user) async {
    return _firestore.collection('users').doc(user.id).set(user.toFirestore());
  }

  Future<List<Attendance>> getAttendances() async {
    final querySnaphot = await _firestore.collection('attendances').get();
    final attendances = querySnaphot.docs.map(Attendance.fromFirestore);
    return attendances.toList();
  }

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
    required User user,
  }) async {
    final day = DateTime(date.year, date.month, date.day);
    final formattedDate = DateFormat('yyyy-MM-dd').format(day);

    final attendanceRef =
        _firestore.collection('attendances').doc(formattedDate);

    try {
      // Try to update an existing attendance
      // If there is none we continue in the catch block
      final fieldValue = isAttending
          ? FieldValue.arrayUnion([user.id])
          : FieldValue.arrayRemove([user.id]);
      await attendanceRef.update({'users': fieldValue});
    } catch (_) {
      // No document found for the given date -> create a new one
      // if the user is attending
      if (!isAttending) return;

      final attendance = Attendance(date: day, userIds: [user.id]);
      await attendanceRef.set(attendance.toFirestore());
    }
  }
}
