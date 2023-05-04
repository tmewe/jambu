part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class _LoginStatusChanged extends LoginEvent {
  _LoginStatusChanged(this.authState);

  final AuthenticationState authState;
}

class LoginRequested extends LoginEvent {}
