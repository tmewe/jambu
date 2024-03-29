import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/user/user.dart';

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
    on<ProfileUpdateColorBlindness>(_onProfileUpdateColorBlindness);
  }

  final UserRepository _userRepository;

  Future<void> _onProfileUpdateAttendances(
    ProfileUpdateAttendances event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedUser =
        await _userRepository.updateRegularAttendances(event.weekdays);

    if (updatedUser != null) {
      emit(state.copyWith(user: updatedUser));
    }
  }

  Future<void> _onProfileDeleteTag(
    ProfileDeleteTag event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedUser = await _userRepository.deleteTag(tagName: event.tag);

    if (updatedUser != null) {
      emit(state.copyWith(user: updatedUser));
    }
  }

  Future<void> _onProfileUpdateColorBlindness(
    ProfileUpdateColorBlindness event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedUser = await _userRepository.updateColorBlindness(
      isColorBlind: event.isColorBlind,
    );

    if (updatedUser != null) {
      emit(state.copyWith(user: updatedUser));
    }
  }
}
