// ignore_for_file: sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Attendance extends Equatable {
  const Attendance({
    required this.date,
    this.userIds = const [],
  });

  final DateTime date;
  final List<String> userIds;

  factory Attendance.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Attendance(
      date: (data?['date'] as Timestamp).toDate(),
      userIds: List.from(data?['users'] as Iterable),
    );
  }

  @override
  List<Object> get props => [date, userIds];

  @override
  String toString() => 'Attendance(date: $date, users: $userIds)';

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'users': userIds,
    };
  }

  Attendance copyWith({
    DateTime? date,
    List<String>? userIds,
  }) {
    return Attendance(
      date: date ?? this.date,
      userIds: userIds ?? this.userIds,
    );
  }
}
