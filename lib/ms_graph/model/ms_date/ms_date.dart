// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ms_date.freezed.dart';
part 'ms_date.g.dart';

@freezed
class MSDate with _$MSDate {
  const factory MSDate({
    @JsonKey(name: 'dateTime') required DateTime date,
    required String timeZone,
  }) = _MSDate;

  factory MSDate.fromJson(Map<String, dynamic> json) => _$MSDateFromJson(json);
}
