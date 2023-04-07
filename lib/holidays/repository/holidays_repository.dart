import 'package:jambu/holidays/datasource/datasource.dart';
import 'package:jambu/model/model.dart';

class HolidaysRepository {
  HolidaysRepository({
    required HolidaysDatasource datasource,
  }) : _datasource = datasource;

  final HolidaysDatasource _datasource;

  Future<List<Holiday>> fetchHolidays() async {
    final holidaysRaw = await _datasource.fetchHolidays();
    return holidaysRaw.map((e) => e.toModel()).toList();
  }
}
