import 'package:collection/collection.dart';
import 'package:jambu/extension/extension.dart';

class Holiday {
  const Holiday({
    required this.name,
    required this.date,
    required this.nationwide,
  });

  final String name;
  final DateTime date;
  final bool nationwide;
}

extension HolidayAtDate on Iterable<Holiday> {
  Holiday? atDate(DateTime date) {
    return firstWhereOrNull((h) => h.date.isSameDay(date) && h.nationwide);
  }
}
