import 'package:equatable/equatable.dart';
import 'package:jambu/calendar/model/calendar_user.dart';

class CalendarDay extends Equatable {
  const CalendarDay({
    required this.date,
    required this.isUserAttending,
    this.users = const [],
    this.reason,
    this.holidayName,
  });

  final DateTime date;
  final bool isUserAttending;
  final List<CalendarUser> users;
  final String? reason;
  final String? holidayName;

  CalendarDay copyWith({
    DateTime? date,
    bool? isUserAttending,
    List<CalendarUser>? users,
    String? reason,
    String? holidayName,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      isUserAttending: isUserAttending ?? this.isUserAttending,
      users: users ?? this.users,
      reason: reason ?? this.reason,
      holidayName: holidayName ?? this.holidayName,
    );
  }

  CalendarDay copyWithoutReason({
    DateTime? date,
    bool? isUserAttending,
    List<CalendarUser>? users,
    String? reason,
    String? holidayName,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      isUserAttending: isUserAttending ?? this.isUserAttending,
      users: users ?? this.users,
      reason: reason,
      holidayName: holidayName ?? this.holidayName,
    );
  }

  @override
  List<Object> get props => [date, isUserAttending, users];
}
