// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ms_calendar.freezed.dart';
part 'ms_calendar.g.dart';

@freezed
class MSCalendar with _$MSCalendar {
  const factory MSCalendar({
    required String name,
    String? id,
    String? hexColor,
  }) = _MSCalendar;

  factory MSCalendar.fromJson(Map<String, dynamic> json) =>
      _$MSCalendarFromJson(json);
}
