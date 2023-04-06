import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jambu/model/model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required User user}) : super(ProfileState(user: user)) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
