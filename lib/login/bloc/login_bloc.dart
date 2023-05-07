import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/user/user.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginState.unknown()) {
    on<LoginRequested>(_onLoginRequested);
    on<_LoginStatusChanged>(_onLoginStatusChanged);

    _authStateSubscription = _authRepository.authStateStream.listen(
      (authState) => add(_LoginStatusChanged(authState)),
    );
  }

  final AuthRepository _authRepository;

  late StreamSubscription<AuthenticationState> _authStateSubscription;

  void _onLoginStatusChanged(
    _LoginStatusChanged event,
    Emitter<LoginState> emit,
  ) {
    switch (event.authState) {
      case AuthenticationState.undefiend:
        emit(const LoginState.unknown());
        break;
      case AuthenticationState.loggedIn:
        emit(const LoginState.loggedIn());
        break;
      case AuthenticationState.loggedOut:
        emit(const LoginState.loggedOut());
        break;
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState.loading());
    try {
      await _authRepository.login();
      emit(const LoginState.loggedIn());
    } catch (e) {
      emit(const LoginState.failure());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
