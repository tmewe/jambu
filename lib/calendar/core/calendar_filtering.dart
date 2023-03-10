import 'package:jambu/calendar/model/model.dart';

class CalendarFiltering {
  CalendarFiltering({required this.filter, required this.weeks});

  final CalendarFilter filter;
  final List<CalendarWeek> weeks;

  List<CalendarWeek> call() {
    if (filter.search.isEmpty && filter.tags.isEmpty) {
      return weeks;
    }
    return [];
  }
}
