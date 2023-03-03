import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jambu/ms_graph/model/model.dart';

part 'ms_event.freezed.dart';
part 'ms_event.g.dart';

@freezed
class MSEvent with _$MSEvent {
  const factory MSEvent({
    required String id,
    required String subject,
    required bool isAllDay,
    required bool isOnlineMeeting,
    required MSDate start,
    required MSDate end,
    required MSEventLocation location,
    required EventStatus showAs,
    bool? isReminderOn,
    MSEventResponseStatus? responseStatus,
  }) = _MSEvent;

  factory MSEvent.fromJson(Map<String, dynamic> json) =>
      _$MSEventFromJson(json);
}

enum EventStatus {
  @JsonValue('free')
  free,
  @JsonValue('tentative')
  tentative,
  @JsonValue('busy')
  busy,
  @JsonValue('oof')
  oof,
  @JsonValue('workingElsewhere')
  workingElsewhere,
  @JsonValue('unknown')
  unknown;
}
