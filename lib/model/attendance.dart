import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Attendance extends Equatable {
  const Attendance({
    required this.date,
    this.userIds = const [],
  });

  factory Attendance.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Attendance(
      date: (data?['date'] as Timestamp).toDate(),
      userIds: List.from(data?['users'] as Iterable),
    );
  }

  final DateTime date;
  final List<String> userIds;

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'users': userIds,
    };
  }

  @override
  String toString() => 'Attendance(date: $date, users: $userIds)';

  @override
  List<Object> get props => [date, userIds];

  Attendance copyWith({
    DateTime? date,
    List<String>? users,
  }) {
    return Attendance(
      date: date ?? this.date,
      userIds: users ?? userIds,
    );
  }
}
