part of 'calendar_bloc.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  const CalendarState({
    this.status = CalendarStatus.initial,
    this.weeks = const [],
    this.selectedWeek = 0,
    this.filter = const CalendarFilter(),
    this.tags = const [],
  });

  final CalendarStatus status;
  final List<CalendarWeek> weeks;
  final int selectedWeek;
  final CalendarFilter filter;
  final List<String> tags;

  List<CalendarWeek> get filteredWeeks => filter.applyAll(weeks);

  @override
  List<Object> get props => [
        status,
        weeks,
        selectedWeek,
        filter,
        tags,
      ];

  CalendarState copyWith({
    CalendarStatus? status,
    List<CalendarWeek>? weeks,
    int? selectedWeek,
    CalendarFilter? filter,
    List<String>? tags,
  }) {
    return CalendarState(
      status: status ?? this.status,
      weeks: weeks ?? this.weeks,
      selectedWeek: selectedWeek ?? this.selectedWeek,
      filter: filter ?? this.filter,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'CalendarState(status: $status)';
  }
}
