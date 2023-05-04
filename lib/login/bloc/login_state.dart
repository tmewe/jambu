part of 'login_bloc.dart';

enum LoginStatus {
  unknown,
  loading,
  loggedIn,
  loggedOut,
  failure,
}

class LoginState extends Equatable {
  const LoginState({required this.status});

  const LoginState.unknown() : this(status: LoginStatus.unknown);
  const LoginState.loading() : this(status: LoginStatus.loading);
  const LoginState.loggedIn() : this(status: LoginStatus.loggedIn);
  const LoginState.loggedOut() : this(status: LoginStatus.loggedOut);
  const LoginState.failure() : this(status: LoginStatus.failure);

  final LoginStatus status;

  @override
  List<Object?> get props => [status];

  @override
  String toString() {
    return '$status';
  }
}
