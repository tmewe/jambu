import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required User user,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(ProfileState(user: user)) {
    on<ProfileUpdateAttendances>(_onProfileUpdateAttendances);
    on<ProfileDeleteTag>(_onProfileDeleteTag);
  }

  final UserRepository _userRepository;

  FutureOr<void> _onProfileUpdateAttendances(
    ProfileUpdateAttendances event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedUser =
        await _userRepository.updateRegularAttendances(event.weekdays);

    if (updatedUser != null) {
      emit(
        state.copyWith(user: updatedUser),
      );
    }
  }

  FutureOr<void> _onProfileDeleteTag(
    ProfileDeleteTag event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedUser = await _userRepository.deleteTag(tagName: event.tag);

    if (updatedUser != null) {
      emit(state.copyWith(user: updatedUser));
    }
  }
}
