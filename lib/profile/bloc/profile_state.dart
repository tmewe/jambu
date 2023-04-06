part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  ProfileState({
    required this.user,
    List<int>? regularAttendances,
  }) {
    regularAttendances = regularAttendances ?? user.regularAttendances;
  }

  final User user;
  late final List<int> regularAttendances;

  @override
  List<Object> get props => [user, regularAttendances];
}
