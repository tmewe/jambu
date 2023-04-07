// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  ProfileState({
    required this.user,
    List<int>? regularAttendances,
    List<String>? tags,
  }) {
    this.regularAttendances = regularAttendances ?? user.regularAttendances;
    this.tags = tags ?? user.tags.map((t) => t.name).toList();
  }

  final User user;
  late final List<int> regularAttendances;
  late final List<String> tags;

  @override
  List<Object> get props => [user, regularAttendances, tags];

  ProfileState copyWith({
    User? user,
    List<int>? regularAttendances,
    List<String>? tags,
  }) {
    return ProfileState(
      user: user ?? this.user,
      regularAttendances: regularAttendances ?? this.regularAttendances,
      tags: tags ?? this.tags,
    );
  }
}
