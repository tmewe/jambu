// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ms_event_response_status.freezed.dart';
part 'ms_event_response_status.g.dart';

@freezed
class MSEventResponseStatus with _$MSEventResponseStatus {
  const factory MSEventResponseStatus({
    ResponseStatus? response,
    DateTime? time,
  }) = _MSEventResponseStatus;

  factory MSEventResponseStatus.fromJson(Map<String, dynamic> json) =>
      _$MSEventResponseStatusFromJson(json);
}

enum ResponseStatus {
  @JsonValue('accepted')
  accepted,
  @JsonValue('organizer')
  organizer,
  @JsonValue('none')
  none,
  @JsonValue('tentativelyAccepted')
  tentativelyAccepted,
  @JsonValue('declined')
  declined,
  @JsonValue('notResponded')
  notResponded;
}
