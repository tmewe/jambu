// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ms_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MSDate _$$_MSDateFromJson(Map<String, dynamic> json) => _$_MSDate(
      date: DateTime.parse(json['dateTime'] as String),
      timeZone: json['timeZone'] as String,
    );

Map<String, dynamic> _$$_MSDateToJson(_$_MSDate instance) => <String, dynamic>{
      'dateTime': instance.date.toIso8601String(),
      'timeZone': instance.timeZone,
    };
