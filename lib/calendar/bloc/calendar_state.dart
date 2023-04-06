part of 'calendar_bloc.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  const CalendarState({
    this.status = CalendarStatus.initial,
    this.weeks = const [],
    this.filter = const CalendarFilter(),
    this.tags = const [],
    this.user,
  });

  final CalendarStatus status;
  final List<CalendarWeek> weeks;
  final CalendarFilter filter;
  final List<String> tags;
  final User? user;

  List<CalendarWeek> get filteredWeeks => filter.applyAll(weeks);

  List<String> get sortedTags {
    tags.sort();
    return tags;
  }

  @override
  List<Object> get props => [
        status,
        weeks,
        filter,
        tags,
      ];

  CalendarState copyWith({
    CalendarStatus? status,
    List<CalendarWeek>? weeks,
    CalendarFilter? filter,
    List<String>? tags,
    User? user,
  }) {
    return CalendarState(
      status: status ?? this.status,
      weeks: weeks ?? this.weeks,
      filter: filter ?? this.filter,
      tags: tags ?? this.tags,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'CalendarState(status: $status)';
  }
}
