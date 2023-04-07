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
