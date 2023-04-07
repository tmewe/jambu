import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/model/model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required User user,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(ProfileState(user: user)) {
    on<ProfileUpdateAttendances>(_onProfileUpdateAttendances);
  }

  final UserRepository _userRepository;

  FutureOr<void> _onProfileUpdateAttendances(
    ProfileUpdateAttendances event,
    Emitter<ProfileState> emit,
  ) async {
    await _userRepository.updateRegularAttendances(event.weekdays);
    final user = _userRepository.currentUser;
    if (user != null) {
      emit(state.copyWith(user: user, regularAttendances: event.weekdays));
    }
  }
}
