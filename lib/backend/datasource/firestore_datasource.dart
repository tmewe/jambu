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
    final querySnaphot =
        await _firestore.collection('attendances').doc(formattedDate).get();
    // No document for the given date
    if (!querySnaphot.exists && isAttending) {
      final attendance = Attendance(date: day, userIds: [user.id]);
      await _saveAttendanceToFirestore(attendance, dateString: formattedDate);
    }
    // Document for given date exists
    else {
      final attendance = Attendance.fromFirestore(querySnaphot);

      final Attendance newAttendance;
      if (!isAttending) {
        newAttendance = attendance.copyWith(
          users: attendance.userIds.where((id) => id != user.id).toList(),
        );
      } else {
        newAttendance = attendance.copyWith(
          users: [...attendance.userIds, user.id],
        );
      }
      await _saveAttendanceToFirestore(
        newAttendance,
        dateString: formattedDate,
      );
    }
  }

  Future<void> _saveAttendanceToFirestore(
    Attendance attendance, {
    required String dateString,
  }) async {
    await _firestore
        .collection('attendances')
        .doc(dateString)
        .set(attendance.toFirestore());
  }
}
