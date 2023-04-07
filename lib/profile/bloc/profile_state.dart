// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  ProfileState({
    required this.user,
    List<int>? regularAttendances,
  }) {
    this.regularAttendances = regularAttendances ?? user.regularAttendances;
  }

  final User user;
  late final List<int> regularAttendances;

  @override
  List<Object> get props => [user, regularAttendances];

  ProfileState copyWith({
    User? user,
    List<int>? regularAttendances,
  }) {
    return ProfileState(
      user: user ?? this.user,
      regularAttendances: regularAttendances ?? this.regularAttendances,
    );
  }
}
