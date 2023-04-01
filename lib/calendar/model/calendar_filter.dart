import 'package:equatable/equatable.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/calendar/model/model.dart';

class CalendarFilter extends Equatable {
  const CalendarFilter({
    this.search = '',
    this.tags = const [],
  });

  final String search;
  final List<String> tags;

  @override
  List<Object> get props => [search, tags];

  List<CalendarWeek> applyAll(List<CalendarWeek> weeks) {
    return CalendarFiltering(filter: this, weeks: weeks)();
  }
}
