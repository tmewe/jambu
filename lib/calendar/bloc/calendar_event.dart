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
    this.reason,
  });

  final DateTime date;
  final bool isAttending;
  final String? reason;

  @override
  List<Object?> get props => [date, isAttending];
}

class CalendarGoToWeek extends CalendarEvent {
  const CalendarGoToWeek({
    required this.weekNumber,
  });

  final int weekNumber;
}

class CalendarFilterUpdate extends CalendarEvent {
  const CalendarFilterUpdate({
    this.searchText = '',
    this.tags = const [],
  });

  final String? searchText;
  final List<String> tags;
}
