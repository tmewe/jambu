import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/repository/repository.dart';
import 'package:jambu/user/user.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const LoginState.initial()) {
    on<LoginInitialCheck>(_onLoginInitialCheck);
    on<LoginRequested>(_onLoginRequested);
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  FutureOr<void> _onLoginInitialCheck(
    LoginInitialCheck event,
    Emitter<LoginState> emit,
  ) async {
    await emit.forEach(
      _userRepository.authStateStream,
      onData: (authState) {
        if (authState == AuthenticationState.loggedOut) {
          return const LoginState(status: LoginStatus.loggedOut);
        } else if (authState == AuthenticationState.loggedIn) {
          return const LoginState(status: LoginStatus.loggedIn);
        }
        return const LoginState(status: LoginStatus.loading);
      },
    );
  }

  FutureOr<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState(status: LoginStatus.loading));
    try {
      await _authRepository.login();
      emit(const LoginState(status: LoginStatus.loggedIn));
    } catch (e) {
      emit(const LoginState(status: LoginStatus.failure));
    }
  }
}
