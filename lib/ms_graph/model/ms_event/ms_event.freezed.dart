// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ms_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MSEvent _$MSEventFromJson(Map<String, dynamic> json) {
  return _MSEvent.fromJson(json);
}

/// @nodoc
mixin _$MSEvent {
  String get id => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  bool get isAllDay => throw _privateConstructorUsedError;
  bool get isOnlineMeeting => throw _privateConstructorUsedError;
  MSDate get start => throw _privateConstructorUsedError;
  MSDate get end => throw _privateConstructorUsedError;
  MSEventLocation get location => throw _privateConstructorUsedError;
  EventStatus get showAs => throw _privateConstructorUsedError;
  bool? get isReminderOn => throw _privateConstructorUsedError;
  MSEventResponseStatus? get responseStatus =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MSEventCopyWith<MSEvent> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MSEventCopyWith<$Res> {
  factory $MSEventCopyWith(MSEvent value, $Res Function(MSEvent) then) =
      _$MSEventCopyWithImpl<$Res, MSEvent>;
  @useResult
  $Res call(
      {String id,
      String subject,
      bool isAllDay,
      bool isOnlineMeeting,
      MSDate start,
      MSDate end,
      MSEventLocation location,
      EventStatus showAs,
      bool? isReminderOn,
      MSEventResponseStatus? responseStatus});

  $MSDateCopyWith<$Res> get start;
  $MSDateCopyWith<$Res> get end;
  $MSEventLocationCopyWith<$Res> get location;
  $MSEventResponseStatusCopyWith<$Res>? get responseStatus;
}

/// @nodoc
class _$MSEventCopyWithImpl<$Res, $Val extends MSEvent>
    implements $MSEventCopyWith<$Res> {
  _$MSEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subject = null,
    Object? isAllDay = null,
    Object? isOnlineMeeting = null,
    Object? start = null,
    Object? end = null,
    Object? location = null,
    Object? showAs = null,
    Object? isReminderOn = freezed,
    Object? responseStatus = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      isAllDay: null == isAllDay
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnlineMeeting: null == isOnlineMeeting
          ? _value.isOnlineMeeting
          : isOnlineMeeting // ignore: cast_nullable_to_non_nullable
              as bool,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as MSDate,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as MSDate,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as MSEventLocation,
      showAs: null == showAs
          ? _value.showAs
          : showAs // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      isReminderOn: freezed == isReminderOn
          ? _value.isReminderOn
          : isReminderOn // ignore: cast_nullable_to_non_nullable
              as bool?,
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as MSEventResponseStatus?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MSDateCopyWith<$Res> get start {
    return $MSDateCopyWith<$Res>(_value.start, (value) {
      return _then(_value.copyWith(start: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MSDateCopyWith<$Res> get end {
    return $MSDateCopyWith<$Res>(_value.end, (value) {
      return _then(_value.copyWith(end: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MSEventLocationCopyWith<$Res> get location {
    return $MSEventLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MSEventResponseStatusCopyWith<$Res>? get responseStatus {
    if (_value.responseStatus == null) {
      return null;
    }

    return $MSEventResponseStatusCopyWith<$Res>(_value.responseStatus!,
        (value) {
      return _then(_value.copyWith(responseStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MSEventCopyWith<$Res> implements $MSEventCopyWith<$Res> {
  factory _$$_MSEventCopyWith(
          _$_MSEvent value, $Res Function(_$_MSEvent) then) =
      __$$_MSEventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String subject,
      bool isAllDay,
      bool isOnlineMeeting,
      MSDate start,
      MSDate end,
      MSEventLocation location,
      EventStatus showAs,
      bool? isReminderOn,
      MSEventResponseStatus? responseStatus});

  @override
  $MSDateCopyWith<$Res> get start;
  @override
  $MSDateCopyWith<$Res> get end;
  @override
  $MSEventLocationCopyWith<$Res> get location;
  @override
  $MSEventResponseStatusCopyWith<$Res>? get responseStatus;
}

/// @nodoc
class __$$_MSEventCopyWithImpl<$Res>
    extends _$MSEventCopyWithImpl<$Res, _$_MSEvent>
    implements _$$_MSEventCopyWith<$Res> {
  __$$_MSEventCopyWithImpl(_$_MSEvent _value, $Res Function(_$_MSEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subject = null,
    Object? isAllDay = null,
    Object? isOnlineMeeting = null,
    Object? start = null,
    Object? end = null,
    Object? location = null,
    Object? showAs = null,
    Object? isReminderOn = freezed,
    Object? responseStatus = freezed,
  }) {
    return _then(_$_MSEvent(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      isAllDay: null == isAllDay
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnlineMeeting: null == isOnlineMeeting
          ? _value.isOnlineMeeting
          : isOnlineMeeting // ignore: cast_nullable_to_non_nullable
              as bool,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as MSDate,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as MSDate,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as MSEventLocation,
      showAs: null == showAs
          ? _value.showAs
          : showAs // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      isReminderOn: freezed == isReminderOn
          ? _value.isReminderOn
          : isReminderOn // ignore: cast_nullable_to_non_nullable
              as bool?,
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as MSEventResponseStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MSEvent implements _MSEvent {
  const _$_MSEvent(
      {required this.id,
      required this.subject,
      required this.isAllDay,
      required this.isOnlineMeeting,
      required this.start,
      required this.end,
      required this.location,
      required this.showAs,
      this.isReminderOn,
      this.responseStatus});

  factory _$_MSEvent.fromJson(Map<String, dynamic> json) =>
      _$$_MSEventFromJson(json);

  @override
  final String id;
  @override
  final String subject;
  @override
  final bool isAllDay;
  @override
  final bool isOnlineMeeting;
  @override
  final MSDate start;
  @override
  final MSDate end;
  @override
  final MSEventLocation location;
  @override
  final EventStatus showAs;
  @override
  final bool? isReminderOn;
  @override
  final MSEventResponseStatus? responseStatus;

  @override
  String toString() {
    return 'MSEvent(id: $id, subject: $subject, isAllDay: $isAllDay, isOnlineMeeting: $isOnlineMeeting, start: $start, end: $end, location: $location, showAs: $showAs, isReminderOn: $isReminderOn, responseStatus: $responseStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MSEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.isAllDay, isAllDay) ||
                other.isAllDay == isAllDay) &&
            (identical(other.isOnlineMeeting, isOnlineMeeting) ||
                other.isOnlineMeeting == isOnlineMeeting) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.showAs, showAs) || other.showAs == showAs) &&
            (identical(other.isReminderOn, isReminderOn) ||
                other.isReminderOn == isReminderOn) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      subject,
      isAllDay,
      isOnlineMeeting,
      start,
      end,
      location,
      showAs,
      isReminderOn,
      responseStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MSEventCopyWith<_$_MSEvent> get copyWith =>
      __$$_MSEventCopyWithImpl<_$_MSEvent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MSEventToJson(
      this,
    );
  }
}

abstract class _MSEvent implements MSEvent {
  const factory _MSEvent(
      {required final String id,
      required final String subject,
      required final bool isAllDay,
      required final bool isOnlineMeeting,
      required final MSDate start,
      required final MSDate end,
      required final MSEventLocation location,
      required final EventStatus showAs,
      final bool? isReminderOn,
      final MSEventResponseStatus? responseStatus}) = _$_MSEvent;

  factory _MSEvent.fromJson(Map<String, dynamic> json) = _$_MSEvent.fromJson;

  @override
  String get id;
  @override
  String get subject;
  @override
  bool get isAllDay;
  @override
  bool get isOnlineMeeting;
  @override
  MSDate get start;
  @override
  MSDate get end;
  @override
  MSEventLocation get location;
  @override
  EventStatus get showAs;
  @override
  bool? get isReminderOn;
  @override
  MSEventResponseStatus? get responseStatus;
  @override
  @JsonKey(ignore: true)
  _$$_MSEventCopyWith<_$_MSEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
