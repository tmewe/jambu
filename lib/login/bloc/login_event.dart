part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class LoginRequested extends LoginEvent {
  @override
  List<Object?> get props => [];
}
