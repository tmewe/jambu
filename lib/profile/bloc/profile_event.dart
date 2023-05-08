part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileUpdateAttendances extends ProfileEvent {
  const ProfileUpdateAttendances({required this.weekdays});

  final List<int> weekdays;

  @override
  List<Object> get props => [weekdays];
}

class ProfileDeleteTag extends ProfileEvent {
  const ProfileDeleteTag({required this.tag});

  final String tag;

  @override
  List<Object> get props => [tag];
}

class ProfileUpdateColorBlindness extends ProfileEvent {
  const ProfileUpdateColorBlindness({required this.isColorBlind});

  final bool isColorBlind;

  @override
  List<Object> get props => [isColorBlind];
}
