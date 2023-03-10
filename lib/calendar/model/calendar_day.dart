import 'package:jambu/calendar/model/calendar_user.dart';

class CalendarDay {
  CalendarDay({
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
}
