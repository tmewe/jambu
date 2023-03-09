part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class CalendarRequested extends CalendarEvent {}

class CalendarAttendanceUpdate extends CalendarEvent {
  const CalendarAttendanceUpdate({
    required this.date,
    required this.isAttending,
  });

  final DateTime date;
  final bool isAttending;

  @override
  List<Object?> get props => [date, isAttending];
}
