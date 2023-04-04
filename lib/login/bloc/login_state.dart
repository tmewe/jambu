part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  loggedIn,
  loggedOut,
  failure,
}

class LoginState extends Equatable {
  const LoginState({required this.status});

  const LoginState.initial() : this(status: LoginStatus.initial);

  final LoginStatus status;

  @override
  List<Object?> get props => [status];
}
