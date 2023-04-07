import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/app_ui/app_ui.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/profile/bloc/profile_bloc.dart';
import 'package:jambu/profile/widgets/widgets.dart';
import 'package:jambu/widgets/widgets.dart';

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
                      _GeneralInfo(user: state.user),
                      const SizedBox(height: 40),
                      _RegularAttendances(
                        selectedWeekdays: state.regularAttendances,
                        onDayTap: (weekdays) => context
                            .read<ProfileBloc>()
                            .add(ProfileUpdateAttendances(weekdays: weekdays)),
                      ),
                      const SizedBox(height: 40),
                      _Tags(
                        tags: state.tags,
                        onDeleteTap: (_) {},
                      ),
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

class _GeneralInfo extends StatelessWidget {
  const _GeneralInfo({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          foregroundImage: NetworkImage(user.imageUrl!),
          radius: 60,
          child: Text(user.name.characters.first),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Text(
              user.jobTitle ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _RegularAttendances extends StatelessWidget {
  const _RegularAttendances({
    required this.selectedWeekdays,
    required this.onDayTap,
  });

  final List<int> selectedWeekdays;
  final WeekdaySelectedCallback onDayTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSectionHeader(
          text: 'An welchen Tagen bist Du normalerweise jede Woche im Büro?',
        ),
        const SizedBox(height: 20),
        RegularAttendancesSelector(
          selectedWeekdays: selectedWeekdays,
          onWeekdayTap: onDayTap,
        ),
      ],
    );
  }
}

typedef StringCallback = void Function(String);

class _Tags extends StatelessWidget {
  const _Tags({
    required this.tags,
    required this.onDeleteTap,
  });

  final List<String> tags;
  final StringCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSectionHeader(
          text: 'Deine Tags:',
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...tags.map((tag) {
              return Chip(
                label: Text(tag),
                onDeleted: () => onDeleteTap(tag),
              );
            }),
          ],
        ),
      ],
    );
  }
}
