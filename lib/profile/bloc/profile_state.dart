// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    required this.user,
  });

  final User user;

  List<String> get tagNames => user.tags.map((t) => t.name).toList();

  @override
  List<Object> get props => [user];

  ProfileState copyWith({User? user}) {
    return ProfileState(
      user: user ?? this.user,
    );
  }
}
