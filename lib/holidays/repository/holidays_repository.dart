import 'package:collection/collection.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/holidays/datasource/datasource.dart';
import 'package:jambu/model/model.dart';

class HolidaysRepository {
  HolidaysRepository({
    required HolidaysDatasource datasource,
  }) : _datasource = datasource;

  final HolidaysDatasource _datasource;

  Future<List<Holiday>> fetchNationwideHolidaysInNextFourWeeks() async {
    final holidaysRaw = await _datasource.fetchHolidays();
    final startDate =
        DateTime.now().firstDateOfWeek.subtract(const Duration(days: 1));
    final endDate =
        DateTime.now().firstDateOfWeek.add(const Duration(days: 29));

    return holidaysRaw.map((e) => e.toModel()).whereNotNull().where((h) {
      return h.nationwide &&
          h.date.isAfter(startDate) &&
          h.date.isBefore(endDate);
    }).toList();
  }
}
