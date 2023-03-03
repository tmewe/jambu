import 'package:freezed_annotation/freezed_annotation.dart';

part 'ms_event_location.freezed.dart';
part 'ms_event_location.g.dart';

@freezed
class MSEventLocation with _$MSEventLocation {
  const factory MSEventLocation({
    required String displayName,
    String? locationType,
  }) = _MSEventLocation;

  factory MSEventLocation.fromJson(Map<String, dynamic> json) =>
      _$MSEventLocationFromJson(json);
}
