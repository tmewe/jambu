// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ms_date.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MSDate _$MSDateFromJson(Map<String, dynamic> json) {
  return _MSDate.fromJson(json);
}

/// @nodoc
mixin _$MSDate {
  @JsonKey(name: 'dateTime')
  DateTime get date => throw _privateConstructorUsedError;
  String get timeZone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MSDateCopyWith<MSDate> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MSDateCopyWith<$Res> {
  factory $MSDateCopyWith(MSDate value, $Res Function(MSDate) then) =
      _$MSDateCopyWithImpl<$Res, MSDate>;
  @useResult
  $Res call({@JsonKey(name: 'dateTime') DateTime date, String timeZone});
}

/// @nodoc
class _$MSDateCopyWithImpl<$Res, $Val extends MSDate>
    implements $MSDateCopyWith<$Res> {
  _$MSDateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? timeZone = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeZone: null == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MSDateCopyWith<$Res> implements $MSDateCopyWith<$Res> {
  factory _$$_MSDateCopyWith(_$_MSDate value, $Res Function(_$_MSDate) then) =
      __$$_MSDateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'dateTime') DateTime date, String timeZone});
}

/// @nodoc
class __$$_MSDateCopyWithImpl<$Res>
    extends _$MSDateCopyWithImpl<$Res, _$_MSDate>
    implements _$$_MSDateCopyWith<$Res> {
  __$$_MSDateCopyWithImpl(_$_MSDate _value, $Res Function(_$_MSDate) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? timeZone = null,
  }) {
    return _then(_$_MSDate(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeZone: null == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MSDate implements _MSDate {
  const _$_MSDate(
      {@JsonKey(name: 'dateTime') required this.date, required this.timeZone});

  factory _$_MSDate.fromJson(Map<String, dynamic> json) =>
      _$$_MSDateFromJson(json);

  @override
  @JsonKey(name: 'dateTime')
  final DateTime date;
  @override
  final String timeZone;

  @override
  String toString() {
    return 'MSDate(date: $date, timeZone: $timeZone)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MSDate &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timeZone, timeZone) ||
                other.timeZone == timeZone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, timeZone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MSDateCopyWith<_$_MSDate> get copyWith =>
      __$$_MSDateCopyWithImpl<_$_MSDate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MSDateToJson(
      this,
    );
  }
}

abstract class _MSDate implements MSDate {
  const factory _MSDate(
      {@JsonKey(name: 'dateTime') required final DateTime date,
      required final String timeZone}) = _$_MSDate;

  factory _MSDate.fromJson(Map<String, dynamic> json) = _$_MSDate.fromJson;

  @override
  @JsonKey(name: 'dateTime')
  DateTime get date;
  @override
  String get timeZone;
  @override
  @JsonKey(ignore: true)
  _$$_MSDateCopyWith<_$_MSDate> get copyWith =>
      throw _privateConstructorUsedError;
}
