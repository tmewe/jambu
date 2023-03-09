part of 'calendar_bloc.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  CalendarState({
    this.status = CalendarStatus.initial,
    this.attendances = const [],
    List<DateTime> displayDates = const [],
  }) {
    if (displayDates.isEmpty) {
      this.displayDates = _weekdays();
    } else {
      this.displayDates = displayDates;
    }
  }

  final CalendarStatus status;
  final List<Attendance> attendances;
  late final List<DateTime> displayDates;

  @override
  List<Object> get props => [status, attendances, displayDates];

  CalendarState copyWith({
    CalendarStatus? status,
    List<Attendance>? attendances,
    List<DateTime>? displayDates,
  }) {
    return CalendarState(
      status: status ?? this.status,
      attendances: attendances ?? this.attendances,
      displayDates: displayDates ?? this.displayDates,
    );
  }
}

List<DateTime> _weekdays() {
  final t = DateTime.now();
  final y = t.subtract(const Duration(days: 1));
  final y2 = t.subtract(const Duration(days: 2));
  final y3 = t.subtract(const Duration(days: 3));
  final to = t.add(const Duration(days: 1));
  return [y3, y2, y, t, to];
}
