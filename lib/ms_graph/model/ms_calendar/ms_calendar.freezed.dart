// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ms_calendar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MSCalendar _$MSCalendarFromJson(Map<String, dynamic> json) {
  return _MSCalendar.fromJson(json);
}

/// @nodoc
mixin _$MSCalendar {
  String get name => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get hexColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MSCalendarCopyWith<MSCalendar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MSCalendarCopyWith<$Res> {
  factory $MSCalendarCopyWith(
          MSCalendar value, $Res Function(MSCalendar) then) =
      _$MSCalendarCopyWithImpl<$Res, MSCalendar>;
  @useResult
  $Res call({String name, String? id, String? hexColor});
}

/// @nodoc
class _$MSCalendarCopyWithImpl<$Res, $Val extends MSCalendar>
    implements $MSCalendarCopyWith<$Res> {
  _$MSCalendarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = freezed,
    Object? hexColor = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      hexColor: freezed == hexColor
          ? _value.hexColor
          : hexColor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MSCalendarCopyWith<$Res>
    implements $MSCalendarCopyWith<$Res> {
  factory _$$_MSCalendarCopyWith(
          _$_MSCalendar value, $Res Function(_$_MSCalendar) then) =
      __$$_MSCalendarCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? id, String? hexColor});
}

/// @nodoc
class __$$_MSCalendarCopyWithImpl<$Res>
    extends _$MSCalendarCopyWithImpl<$Res, _$_MSCalendar>
    implements _$$_MSCalendarCopyWith<$Res> {
  __$$_MSCalendarCopyWithImpl(
      _$_MSCalendar _value, $Res Function(_$_MSCalendar) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = freezed,
    Object? hexColor = freezed,
  }) {
    return _then(_$_MSCalendar(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      hexColor: freezed == hexColor
          ? _value.hexColor
          : hexColor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MSCalendar implements _MSCalendar {
  const _$_MSCalendar({required this.name, this.id, this.hexColor});

  factory _$_MSCalendar.fromJson(Map<String, dynamic> json) =>
      _$$_MSCalendarFromJson(json);

  @override
  final String name;
  @override
  final String? id;
  @override
  final String? hexColor;

  @override
  String toString() {
    return 'MSCalendar(name: $name, id: $id, hexColor: $hexColor)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MSCalendar &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hexColor, hexColor) ||
                other.hexColor == hexColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, id, hexColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MSCalendarCopyWith<_$_MSCalendar> get copyWith =>
      __$$_MSCalendarCopyWithImpl<_$_MSCalendar>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MSCalendarToJson(
      this,
    );
  }
}

abstract class _MSCalendar implements MSCalendar {
  const factory _MSCalendar(
      {required final String name,
      final String? id,
      final String? hexColor}) = _$_MSCalendar;

  factory _MSCalendar.fromJson(Map<String, dynamic> json) =
      _$_MSCalendar.fromJson;

  @override
  String get name;
  @override
  String? get id;
  @override
  String? get hexColor;
  @override
  @JsonKey(ignore: true)
  _$$_MSCalendarCopyWith<_$_MSCalendar> get copyWith =>
      throw _privateConstructorUsedError;
}
