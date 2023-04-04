part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitialCheck extends LoginEvent {}

class LoginRequested extends LoginEvent {}
