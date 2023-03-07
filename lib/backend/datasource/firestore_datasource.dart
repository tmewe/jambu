import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:jambu/model/model.dart';

class FirestoreDatasource {
  FirestoreDatasource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<User>> getUsers() async {
    final querySnaphot = await _firestore.collection('users').get();
    final users = querySnaphot.docs.map((e) => User.fromJson(e.data()));
    return users.toList();
  }

  Future<void> updateUser(User user) async {
    final userJson = user.toJson();
    return _firestore.collection('users').doc(user.id).set(userJson);
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
      await _firestore.collection('attendances').doc(formattedDate).set(
        {
          'users': [user.id]
        },
      );
    }
    debugPrint('$querySnaphot');
  }
}
