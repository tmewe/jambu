part of 'auth_check_bloc.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
}

class AuthCheckState extends Equatable {
  const AuthCheckState({required this.status});

  const AuthCheckState.initial() : this(status: AuthStatus.unknown);

  final AuthStatus status;

  @override
  List<Object> get props => [status];
}
