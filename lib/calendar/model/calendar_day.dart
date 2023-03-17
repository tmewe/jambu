// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:jambu/calendar/model/calendar_user.dart';

class CalendarDay extends Equatable {
  const CalendarDay({
    required this.date,
    required this.isUserAttending,
    this.users = const [],
  });

  final DateTime date;
  final bool isUserAttending;
  final List<CalendarUser> users;

  CalendarDay copyWith({
    DateTime? date,
    bool? isUserAttending,
    List<CalendarUser>? users,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      isUserAttending: isUserAttending ?? this.isUserAttending,
      users: users ?? this.users,
    );
  }

  @override
  List<Object> get props => [date, isUserAttending, users];
}
