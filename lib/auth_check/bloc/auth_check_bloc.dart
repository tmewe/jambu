import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jambu/repository/repository.dart';

part 'auth_check_event.dart';
part 'auth_check_state.dart';

class AuthCheckBloc extends Bloc<AuthCheckEvent, AuthCheckState> {
  AuthCheckBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AuthCheckState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  final UserRepository _userRepository;

  FutureOr<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthCheckState> emit,
  ) async {
    await emit.forEach(
      _userRepository.userStream,
      onData: (User? user) {
        final authStatus = user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated;
        return AuthCheckState(status: authStatus);
      },
    );
  }
}
