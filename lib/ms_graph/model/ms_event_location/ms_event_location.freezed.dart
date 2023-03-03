// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ms_event_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MSEventLocation _$MSEventLocationFromJson(Map<String, dynamic> json) {
  return _MSEventLocation.fromJson(json);
}

/// @nodoc
mixin _$MSEventLocation {
  String get displayName => throw _privateConstructorUsedError;
  String? get locationType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MSEventLocationCopyWith<MSEventLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MSEventLocationCopyWith<$Res> {
  factory $MSEventLocationCopyWith(
          MSEventLocation value, $Res Function(MSEventLocation) then) =
      _$MSEventLocationCopyWithImpl<$Res, MSEventLocation>;
  @useResult
  $Res call({String displayName, String? locationType});
}

/// @nodoc
class _$MSEventLocationCopyWithImpl<$Res, $Val extends MSEventLocation>
    implements $MSEventLocationCopyWith<$Res> {
  _$MSEventLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? locationType = freezed,
  }) {
    return _then(_value.copyWith(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: freezed == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MSEventLocationCopyWith<$Res>
    implements $MSEventLocationCopyWith<$Res> {
  factory _$$_MSEventLocationCopyWith(
          _$_MSEventLocation value, $Res Function(_$_MSEventLocation) then) =
      __$$_MSEventLocationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String displayName, String? locationType});
}

/// @nodoc
class __$$_MSEventLocationCopyWithImpl<$Res>
    extends _$MSEventLocationCopyWithImpl<$Res, _$_MSEventLocation>
    implements _$$_MSEventLocationCopyWith<$Res> {
  __$$_MSEventLocationCopyWithImpl(
      _$_MSEventLocation _value, $Res Function(_$_MSEventLocation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? locationType = freezed,
  }) {
    return _then(_$_MSEventLocation(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: freezed == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MSEventLocation implements _MSEventLocation {
  const _$_MSEventLocation({required this.displayName, this.locationType});

  factory _$_MSEventLocation.fromJson(Map<String, dynamic> json) =>
      _$$_MSEventLocationFromJson(json);

  @override
  final String displayName;
  @override
  final String? locationType;

  @override
  String toString() {
    return 'MSEventLocation(displayName: $displayName, locationType: $locationType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MSEventLocation &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, displayName, locationType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MSEventLocationCopyWith<_$_MSEventLocation> get copyWith =>
      __$$_MSEventLocationCopyWithImpl<_$_MSEventLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MSEventLocationToJson(
      this,
    );
  }
}

abstract class _MSEventLocation implements MSEventLocation {
  const factory _MSEventLocation(
      {required final String displayName,
      final String? locationType}) = _$_MSEventLocation;

  factory _MSEventLocation.fromJson(Map<String, dynamic> json) =
      _$_MSEventLocation.fromJson;

  @override
  String get displayName;
  @override
  String? get locationType;
  @override
  @JsonKey(ignore: true)
  _$$_MSEventLocationCopyWith<_$_MSEventLocation> get copyWith =>
      throw _privateConstructorUsedError;
}
