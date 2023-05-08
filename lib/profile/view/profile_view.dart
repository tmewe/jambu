import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/profile/bloc/profile_bloc.dart';
import 'package:jambu/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return _ProfileContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GeneralInfo(user: state.user),
              const SizedBox(height: AppSpacing.xxl),
              _RegularAttendances(
                selectedWeekdays: state.user.regularAttendances,
                onDayTap: (weekdays) => context
                    .read<ProfileBloc>()
                    .add(ProfileUpdateAttendances(weekdays: weekdays)),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _Tags(
                tags: state.tagNames,
                onDeleteTap: (tag) {
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const SelectableText('Täg löschen?'),
                      content: SelectableText(
                        "Möchtest du den Täg '$tag' wirklich löschen?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Abbrechen'),
                        ),
                        FilledButton(
                          onPressed: () {
                            context
                                .read<ProfileBloc>()
                                .add(ProfileDeleteTag(tag: tag));
                            context.pop();
                          },
                          child: const Text('Löschen'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              _ColorBlindness(isColorBlind: state.user.isColorBlind),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileContainer extends StatelessWidget {
  const _ProfileContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SelectableText('Profil'),
      ),
      body: SingleChildScrollView(
        child: Align(
          child: Container(
            constraints: const BoxConstraints(maxWidth: maxElementWidth),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: child,
            ),
          ),
        ),
      ),
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
          backgroundColor: AppColors.platinumGrey,
          foregroundImage: NetworkImage(user.imageUrl ?? ''),
          radius: 50,
          child: Text(user.name.characters.first),
        ),
        const SizedBox(width: AppSpacing.xl),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              user.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            SelectableText(
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
        const _ProfileSectionHeader(
          text: 'An welchen Tagen bist Du normalerweise jede Woche im Büro?',
        ),
        const SizedBox(height: AppSpacing.l),
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
        const _ProfileSectionHeader(
          text: 'Deine Tägs:',
        ),
        const SizedBox(height: AppSpacing.m),
        if (tags.isNotEmpty)
          Wrap(
            spacing: 5,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.clear, size: 18),
                  deleteButtonTooltipMessage: 'Löschen',
                  onDeleted: () => onDeleteTap(tag),
                );
              }),
            ],
          ),
        if (tags.isEmpty)
          SelectableText(
            'Hier erscheinen deine Tägs, sobald du welche hinzugefügt hast.',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.frenchGrey,
                ),
          ),
      ],
    );
  }
}

class _ColorBlindness extends StatelessWidget {
  const _ColorBlindness({required this.isColorBlind});

  final bool isColorBlind;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ProfileSectionHeader(text: 'Hast du eine Rot-Grün-Schwäche?'),
        const SizedBox(height: AppSpacing.m),
        Switch(
          value: isColorBlind,
          onChanged: (value) {
            context.read<ProfileBloc>().add(
                  ProfileUpdateColorBlindness(isColorBlind: value),
                );
          },
        ),
      ],
    );
  }
}

class _ProfileSectionHeader extends StatelessWidget {
  const _ProfileSectionHeader({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
