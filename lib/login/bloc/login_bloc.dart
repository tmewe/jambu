import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/repository/repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepository userRepository,
    required FirestoreRepository firestoreRepository,
  })  : _userRepository = userRepository,
        _firestoreRepository = firestoreRepository,
        super(const LoginState.initial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  final AuthRepository _userRepository;
  final FirestoreRepository _firestoreRepository;

  FutureOr<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState(status: LoginStatus.loading));
    try {
      final credentials = await _userRepository.login();
      emit(const LoginState(status: LoginStatus.success));

      if (credentials.user != null) {
        await _firestoreRepository.updateUser(credentials.user!);
      }
    } catch (e) {
      emit(const LoginState(status: LoginStatus.failure));
    }
  }
}
