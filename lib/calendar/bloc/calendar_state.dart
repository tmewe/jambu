// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'calendar_bloc.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  const CalendarState({
    this.status = CalendarStatus.initial,
    this.weeks = const [],
    this.selectedWeek = 0,
    this.filter = const CalendarFilter(),
  });

  final CalendarStatus status;
  final List<CalendarWeek> weeks;
  final int selectedWeek;
  final CalendarFilter filter;

  @override
  List<Object> get props => [status, weeks, selectedWeek, filter];

  CalendarState copyWith({
    CalendarStatus? status,
    List<CalendarWeek>? weeks,
    int? selectedWeek,
    CalendarFilter? filter,
  }) {
    return CalendarState(
      status: status ?? this.status,
      weeks: weeks ?? this.weeks,
      selectedWeek: selectedWeek ?? this.selectedWeek,
      filter: filter ?? this.filter,
    );
  }
}
