part of 'auth_check_bloc.dart';

abstract class AuthCheckEvent extends Equatable {
  const AuthCheckEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthCheckEvent {}
