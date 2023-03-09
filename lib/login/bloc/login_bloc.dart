import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/repository/repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginState.initial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  final AuthRepository _authRepository;

  FutureOr<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState(status: LoginStatus.loading));
    try {
      await _authRepository.login();
      emit(const LoginState(status: LoginStatus.success));
    } catch (e) {
      emit(const LoginState(status: LoginStatus.failure));
    }
  }
}
