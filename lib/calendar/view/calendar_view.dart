import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/model/calendar_week.dart';
import 'package:jambu/calendar/widgets/calendar_day_overview.dart';
import 'package:jambu/calendar/widgets/tag_filter.dart';
import 'package:jambu/calendar/widgets/widgets.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/user/user.dart';

final _dateFormat = DateFormat('dd.MM');

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final _searchTextController = TextEditingController();
  int _selectedWeekIndex = 0;
  var _explanationsShowing = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (BuildContext context, CalendarState state) {
        if (state.user != null &&
            !state.user!.explanationsCompleted &&
            !_explanationsShowing) {
          final bloc = context.read<CalendarBloc>();
          _explanationsShowing = true;

          showDialog<void>(
            barrierDismissible: false,
            context: context,
            builder: (context) => _ExplanationsAlert(
              onCompleteTap: () {
                bloc.add(CalenderExplanationsCompleted());
                context.pop();
                _explanationsShowing = false;
              },
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status != CalendarStatus.success) {
          return _LoadingView(user: state.user);
        }

        final selectedWeek = state.filteredWeeks[_selectedWeekIndex];
        final startDate = _dateFormat.format(selectedWeek.days.first.date);
        final endDate = _dateFormat.format(selectedWeek.days.last.date);

        return _ContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppBar(user: state.user),
              SearchBar(
                padding: const EdgeInsets.symmetric(vertical: 5),
                controller: _searchTextController,
                onChanged: (searchText) {
                  setState(() {});
                  context.read<CalendarBloc>().add(
                        CalendarSearchTextUpdate(
                          searchText: searchText,
                        ),
                      );
                },
              ),
              if (state.tags.isNotEmpty)
                TagFilter(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  tags: state.sortedTags,
                  selectedTags: state.filter.tags,
                  onSelectTag: (tag, isSelected) {
                    final tags = isSelected
                        ? [...state.filter.tags, tag]
                        : state.filter.tags.where((t) => t != tag).toList();

                    context
                        .read<CalendarBloc>()
                        .add(CalendarTagFilterUpdate(tags: tags));
                  },
                ),
              const SizedBox(height: 40),
              _WeekSelector(
                startDate: startDate,
                endDate: endDate,
                selectedWeekIndex: _selectedWeekIndex,
                onPreviousTap: _selectedWeekIndex > 0
                    ? () => setState(() => _selectedWeekIndex--)
                    : null,
                onNextTap: _selectedWeekIndex < state.weeks.length - 1
                    ? () => setState(() => _selectedWeekIndex++)
                    : null,
              ),
              const SizedBox(height: 20),
              _CalendarDays(
                selectedWeek: selectedWeek,
                sortedTags: state.sortedTags,
                user: state.user,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContentWrapper extends StatelessWidget {
  const _ContentWrapper({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxElementWidth),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarDays extends StatelessWidget {
  const _CalendarDays({
    required this.selectedWeek,
    required this.sortedTags,
    required this.user,
  });

  final CalendarWeek selectedWeek;
  final List<String> sortedTags;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth =
            (constraints.maxWidth - 100) / selectedWeek.days.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              'Meine Anwesenheit',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.frenchGrey,
                  ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedWeek.days.mapIndexed((index, day) {
                return SizedBox(
                  width: columnWidth,
                  height: 170,
                  child: CalendarDayOverview(
                    day: day,
                    tags: sortedTags,
                    isBestChoice:
                        selectedWeek.bestChoices.contains(day.date.weekday),
                    isColorBlind: user?.isColorBlind ?? false,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SelectableText(
              'Vorraussichtliche Anwesenheit Kolleg*innen',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.frenchGrey,
                  ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedWeek.days.map((day) {
                return SizedBox(
                  width: columnWidth,
                  child: CalendarDayUsersList(
                    day: day,
                    tags: sortedTags,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _WeekSelector extends StatelessWidget {
  const _WeekSelector({
    required this.startDate,
    required this.endDate,
    required this.selectedWeekIndex,
    this.onNextTap,
    this.onPreviousTap,
  });

  final String startDate;
  final String endDate;
  final int selectedWeekIndex;
  final VoidCallback? onNextTap;
  final VoidCallback? onPreviousTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$startDate - $endDate',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(width: 20),
        const Divider(thickness: 3, color: Colors.black),
        IconButton(
          onPressed: onPreviousTap,
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton(
          onPressed: onNextTap,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'jambu',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColors.outerSpaceGrey,
              ),
        ),
        const Spacer(),
        MenuAnchor(
          alignmentOffset: const Offset(-62, 0),
          menuChildren: [
            MenuItemButton(
              child: const Text('Mein Profil'),
              onPressed: () {
                final router = GoRouter.of(context);
                router
                  ..goNamed('profile', extra: user)
                  ..addListener(
                    () => _routerListener(
                      router: router,
                      context: context,
                    ),
                  );
              },
            ),
            MenuItemButton(
              trailingIcon: const Icon(
                Icons.logout,
                size: 18,
              ),
              child: const Text('Abmelden'),
              onPressed: () => context.read<AuthRepository>().logout(),
            ),
          ],
          builder: (context, controller, child) => IconButton(
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
            icon: CircleAvatar(
              backgroundColor: AppColors.platinumGrey,
              foregroundImage: NetworkImage(user?.imageUrl ?? ''),
              child: Text(user?.name.characters.first ?? ''),
            ),
          ),
        ),
      ],
    );
  }

  void _routerListener({
    required GoRouter router,
    required BuildContext context,
  }) {
    if (!GoRouter.of(context).location.contains('profile')) {
      context.read<CalendarBloc>().add(CalendarRefresh());
    }
    router.removeListener(
      () => _routerListener(router: router, context: context),
    );
  }
}

class _ExplanationsAlert extends StatefulWidget {
  const _ExplanationsAlert({
    required this.onCompleteTap,
  });

  final VoidCallback onCompleteTap;

  @override
  State<_ExplanationsAlert> createState() => _ExplanationsAlertState();
}

class _ExplanationsAlertState extends State<_ExplanationsAlert> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ConstrainedBox(
        constraints: BoxConstraints.tight(const Size(550, 650)),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _FavoritesExplanation(
              onCompleteTap: () => _pageController.nextPage(
                duration: PageTransition.duration,
                curve: PageTransition.curve,
              ),
            ),
            _TagsExplanation(
              onBackTap: () => _pageController.previousPage(
                duration: PageTransition.duration,
                curve: PageTransition.curve,
              ),
              onCompleteTap: widget.onCompleteTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesExplanation extends StatelessWidget {
  const _FavoritesExplanation({
    required this.onCompleteTap,
  });

  final VoidCallback onCompleteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        SelectableText(
          'Favoriten',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Image.asset('assets/images/favorites.png'),
        const SizedBox(height: 20),
        const SelectableText(
          'Mit dem Herz kannst du bestimmte Kolleg*innen '
          'favorisieren. Diese erscheinen dann immer oben '
          'in deiner Übersicht. Außerdem zeigt dir jambu auf '
          'Basis deiner Favoriten an, welche Tage die optimalen '
          'Bürotage für dich wären.',
        ),
        const SizedBox(height: 5),
        const SelectableText(
          'Für einen noch schnelleren Überblick werden deine '
          'Favoriten mit Outlook gesynct.',
        ),
        const Spacer(),
        Row(
          children: [
            const Spacer(),
            FilledButton(
              onPressed: onCompleteTap,
              child: const Text('Nice'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TagsExplanation extends StatelessWidget {
  const _TagsExplanation({
    required this.onBackTap,
    required this.onCompleteTap,
  });

  final VoidCallback onBackTap;
  final VoidCallback onCompleteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        SelectableText(
          'Tägs',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Image.asset('assets/images/tags.png'),
        const SizedBox(height: 20),
        const SelectableText(
          'Mit dem Plus kannst du bestimmten Kolleg*innen Tägs zuordnen '
          "und auf diese Art und Weise gruppieren. Mit dem 'X' wird der Täg "
          'von der Nutzer*in entfernt. Wenn du einen Täg komplett '
          'löschen möchtest, geht das über dein Profil. Tägs umbennen kannst '
          'du einfach per Klick auf den Täg.',
        ),
        const SizedBox(height: 5),
        const SelectableText(
          'Sowohl deine Favoriten, als auch deine Tägs sind personalisiert '
          'und somit nur für dich einsehbar.',
        ),
        const SizedBox(height: 5),
        const SelectableText(
          'Für einen noch schnelleren Überblick werden deine '
          'Tägs mit Outlook gesynct.',
        ),
        const Spacer(),
        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: onBackTap,
              child: const Text('Zurück'),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: onCompleteTap,
              child: const Text('Fertig'),
            ),
          ],
        )
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({
    this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxElementWidth),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _AppBar(user: user),
                const Spacer(),
                const CircularProgressIndicator(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
