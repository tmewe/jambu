import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  Attendance({
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
}
