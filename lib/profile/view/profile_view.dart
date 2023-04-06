import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/app_ui/app_ui.dart';
import 'package:jambu/profile/bloc/profile_bloc.dart';
import 'package:jambu/profile/widgets/regular_attendances.dart';
import 'package:jambu/profile/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil'),
          ),
          body: SingleChildScrollView(
            child: Align(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxElementWidth),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GeneralInfo(user: state.user),
                      const SizedBox(height: 40),
                      const RegularAttendances(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
