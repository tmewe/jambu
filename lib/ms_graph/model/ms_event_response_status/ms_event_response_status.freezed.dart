// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ms_event_response_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MSEventResponseStatus _$MSEventResponseStatusFromJson(
    Map<String, dynamic> json) {
  return _MSEventResponseStatus.fromJson(json);
}

/// @nodoc
mixin _$MSEventResponseStatus {
  ResponseStatus? get response => throw _privateConstructorUsedError;
  DateTime? get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MSEventResponseStatusCopyWith<MSEventResponseStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MSEventResponseStatusCopyWith<$Res> {
  factory $MSEventResponseStatusCopyWith(MSEventResponseStatus value,
          $Res Function(MSEventResponseStatus) then) =
      _$MSEventResponseStatusCopyWithImpl<$Res, MSEventResponseStatus>;
  @useResult
  $Res call({ResponseStatus? response, DateTime? time});
}

/// @nodoc
class _$MSEventResponseStatusCopyWithImpl<$Res,
        $Val extends MSEventResponseStatus>
    implements $MSEventResponseStatusCopyWith<$Res> {
  _$MSEventResponseStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = freezed,
    Object? time = freezed,
  }) {
    return _then(_value.copyWith(
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as ResponseStatus?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MSEventResponseStatusCopyWith<$Res>
    implements $MSEventResponseStatusCopyWith<$Res> {
  factory _$$_MSEventResponseStatusCopyWith(_$_MSEventResponseStatus value,
          $Res Function(_$_MSEventResponseStatus) then) =
      __$$_MSEventResponseStatusCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ResponseStatus? response, DateTime? time});
}

/// @nodoc
class __$$_MSEventResponseStatusCopyWithImpl<$Res>
    extends _$MSEventResponseStatusCopyWithImpl<$Res, _$_MSEventResponseStatus>
    implements _$$_MSEventResponseStatusCopyWith<$Res> {
  __$$_MSEventResponseStatusCopyWithImpl(_$_MSEventResponseStatus _value,
      $Res Function(_$_MSEventResponseStatus) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = freezed,
    Object? time = freezed,
  }) {
    return _then(_$_MSEventResponseStatus(
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as ResponseStatus?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MSEventResponseStatus implements _MSEventResponseStatus {
  const _$_MSEventResponseStatus({this.response, this.time});

  factory _$_MSEventResponseStatus.fromJson(Map<String, dynamic> json) =>
      _$$_MSEventResponseStatusFromJson(json);

  @override
  final ResponseStatus? response;
  @override
  final DateTime? time;

  @override
  String toString() {
    return 'MSEventResponseStatus(response: $response, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MSEventResponseStatus &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, response, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MSEventResponseStatusCopyWith<_$_MSEventResponseStatus> get copyWith =>
      __$$_MSEventResponseStatusCopyWithImpl<_$_MSEventResponseStatus>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MSEventResponseStatusToJson(
      this,
    );
  }
}

abstract class _MSEventResponseStatus implements MSEventResponseStatus {
  const factory _MSEventResponseStatus(
      {final ResponseStatus? response,
      final DateTime? time}) = _$_MSEventResponseStatus;

  factory _MSEventResponseStatus.fromJson(Map<String, dynamic> json) =
      _$_MSEventResponseStatus.fromJson;

  @override
  ResponseStatus? get response;
  @override
  DateTime? get time;
  @override
  @JsonKey(ignore: true)
  _$$_MSEventResponseStatusCopyWith<_$_MSEventResponseStatus> get copyWith =>
      throw _privateConstructorUsedError;
}
