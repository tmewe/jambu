import 'package:equatable/equatable.dart';
import 'package:jambu/calendar/model/calendar_user.dart';

class CalendarDay extends Equatable {
  const CalendarDay({
    required this.date,
    required this.isUserAttending,
    this.isHoliday = false,
    this.users = const [],
    this.reason,
  });

  final DateTime date;
  final bool isUserAttending;
  final List<CalendarUser> users;
  final bool isHoliday;
  final String? reason;

  CalendarDay copyWith({
    DateTime? date,
    bool? isUserAttending,
    List<CalendarUser>? users,
    String? reason,
    bool? isHoliday,
    String? holidayName,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      isUserAttending: isUserAttending ?? this.isUserAttending,
      users: users ?? this.users,
      isHoliday: isHoliday ?? this.isHoliday,
      reason: reason ?? this.reason,
    );
  }

  CalendarDay copyWithoutReason({
    DateTime? date,
    bool? isUserAttending,
    List<CalendarUser>? users,
    String? reason,
    bool? isHoliday,
    String? holidayName,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      isUserAttending: isUserAttending ?? this.isUserAttending,
      users: users ?? this.users,
      isHoliday: isHoliday ?? this.isHoliday,
      reason: reason,
    );
  }

  @override
  List<Object> get props => [date, isUserAttending, users, isHoliday];
}
