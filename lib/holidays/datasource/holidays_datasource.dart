import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jambu/holidays/datasource/holiday_raw.dart';

class HolidaysDatasource {
  Future<List<HolidayRaw>> fetchHolidays() async {
    final holidaysString = await rootBundle.loadString('assets/holidays.json');
    final holidaysJson = jsonDecode(holidaysString) as Iterable;
    final holidaysRaw = holidaysJson.map(HolidayRaw.fromJson).toList();
    debugPrint(holidaysRaw.toString());
    return holidaysRaw;
  }
}
