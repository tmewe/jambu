import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(),
      child: const ProfileView(),
    );
  }
}
