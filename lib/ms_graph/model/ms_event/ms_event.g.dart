// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ms_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MSEvent _$$_MSEventFromJson(Map<String, dynamic> json) => _$_MSEvent(
      id: json['id'] as String,
      subject: json['subject'] as String,
      isAllDay: json['isAllDay'] as bool,
      isOnlineMeeting: json['isOnlineMeeting'] as bool,
      start: MSDate.fromJson(json['start'] as Map<String, dynamic>),
      end: MSDate.fromJson(json['end'] as Map<String, dynamic>),
      location:
          MSEventLocation.fromJson(json['location'] as Map<String, dynamic>),
      showAs: $enumDecode(_$EventStatusEnumMap, json['showAs']),
      isReminderOn: json['isReminderOn'] as bool?,
      responseStatus: json['responseStatus'] == null
          ? null
          : MSEventResponseStatus.fromJson(
              json['responseStatus'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MSEventToJson(_$_MSEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'isAllDay': instance.isAllDay,
      'isOnlineMeeting': instance.isOnlineMeeting,
      'start': instance.start,
      'end': instance.end,
      'location': instance.location,
      'showAs': _$EventStatusEnumMap[instance.showAs]!,
      'isReminderOn': instance.isReminderOn,
      'responseStatus': instance.responseStatus,
    };

const _$EventStatusEnumMap = {
  EventStatus.free: 'free',
  EventStatus.tentative: 'tentative',
  EventStatus.busy: 'busy',
  EventStatus.oof: 'oof',
  EventStatus.workingElsewhere: 'workingElsewhere',
  EventStatus.unknown: 'unknown',
};
