// ignore_for_file: sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:jambu/model/entry.dart';

@immutable
class Attendance extends Equatable {
  const Attendance({
    required this.date,
    this.present = const [],
  });

  Attendance.attending({
    required this.date,
    required List<String> userIds,
  }) : present = userIds.map((e) => Entry(userId: e)).toList();

  final DateTime date;
  final List<Entry> present;

  factory Attendance.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Attendance(
      date: (data?['date'] as Timestamp).toDate(),
      present: List<Map<String, dynamic>>.from(data?['users'] as Iterable)
          .map(Entry.fromMap)
          .toList(),
    );
  }

  @override
  List<Object> get props => [date, present];

  @override
  String toString() => 'Attendance(date: $date, users: $present)';

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'users': present.map((e) => e.toMap()),
    };
  }

  Attendance copyWith({
    DateTime? date,
    List<Entry>? present,
  }) {
    return Attendance(
      date: date ?? this.date,
      present: present ?? this.present,
    );
  }
}
