// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'calendar_bloc.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  CalendarState({
    this.status = CalendarStatus.initial,
    this.attendances = const [],
    this.userAttendances = const [],
    List<DateTime> displayDates = const [],
  }) {
    if (displayDates.isEmpty) {
      this.displayDates = Week(date: DateTime.now()).workingDays;
    } else {
      this.displayDates = displayDates;
    }
  }

  final CalendarStatus status;
  // Attendances of all users
  final List<Attendance> attendances;
  // Attendances of current user
  final List<DateTime> userAttendances;
  late final List<DateTime> displayDates;

  @override
  List<Object> get props => [
        status,
        attendances,
        displayDates,
        userAttendances,
      ];

  CalendarState copyWith({
    CalendarStatus? status,
    List<Attendance>? attendances,
    List<DateTime>? userAttendances,
    List<DateTime>? displayDates,
  }) {
    return CalendarState(
      status: status ?? this.status,
      attendances: attendances ?? this.attendances,
      userAttendances: userAttendances ?? this.userAttendances,
      displayDates: displayDates ?? this.displayDates,
    );
  }
}
