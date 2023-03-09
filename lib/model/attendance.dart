// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Attendance extends Equatable {
  const Attendance({
    required this.date,
    this.users = const [],
  });

  factory Attendance.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Attendance(
      date: (data?['date'] as Timestamp).toDate(),
      users: List.from(data?['users'] as Iterable),
    );
  }

  final DateTime date;
  final List<String> users;

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'users': users,
    };
  }

  @override
  String toString() => 'Attendance(date: $date, users: $users)';

  @override
  List<Object> get props => [date, users];
}
