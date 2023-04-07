import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/model/model.dart';

class CalendarUpdate {
  CalendarUpdate({
    required this.weeks,
    this.user,
  });

  final List<CalendarWeek> weeks;
  final User? user;
}
