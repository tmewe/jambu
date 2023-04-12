import 'package:collection/collection.dart';
import 'package:jambu/holidays/datasource/datasource.dart';
import 'package:jambu/model/model.dart';

class HolidaysRepository {
  HolidaysRepository({
    required HolidaysDatasource datasource,
  }) : _datasource = datasource;

  final HolidaysDatasource _datasource;

  Future<List<Holiday>> fetchNationwideHolidaysInNextFourWeeks() async {
    final holidaysRaw = await _datasource.fetchHolidays();
    return holidaysRaw.map((e) => e.toModel()).whereNotNull().where((h) {
      return h.nationwide &&
          h.date.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
          h.date.isBefore(DateTime.now().add(const Duration(days: 29)));
    }).toList();
  }
}
