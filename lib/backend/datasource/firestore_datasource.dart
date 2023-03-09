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
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final querySnaphot =
        await _firestore.collection('attendances').doc(formattedDate).get();
    if (querySnaphot.data() == null) {
      final attendance = Attendance(date: date, users: [user.id]);
      await _firestore
          .collection('attendances')
          .doc(formattedDate)
          .set(attendance.toFirestore());
    }
  }
}
