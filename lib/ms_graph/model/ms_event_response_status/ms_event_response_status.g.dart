// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ms_event_response_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MSEventResponseStatus _$$_MSEventResponseStatusFromJson(
        Map<String, dynamic> json) =>
    _$_MSEventResponseStatus(
      response: $enumDecodeNullable(_$ResponseStatusEnumMap, json['response']),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$$_MSEventResponseStatusToJson(
        _$_MSEventResponseStatus instance) =>
    <String, dynamic>{
      'response': _$ResponseStatusEnumMap[instance.response],
      'time': instance.time?.toIso8601String(),
    };

const _$ResponseStatusEnumMap = {
  ResponseStatus.accepted: 'accepted',
  ResponseStatus.organizer: 'organizer',
  ResponseStatus.none: 'none',
  ResponseStatus.tentativelyAccepted: 'tentativelyAccepted',
  ResponseStatus.declined: 'declined',
  ResponseStatus.notResponded: 'notResponded',
};
