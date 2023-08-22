import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/model/calendar_day.dart';
import 'package:jambu/calendar/model/calendar_week.dart';
import 'package:jambu/calendar/widgets/calendar_day_overview.dart';
import 'package:jambu/calendar/widgets/tag_filter.dart';
import 'package:jambu/calendar/widgets/widgets.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/user/user.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _dateFormat = DateFormat('dd.MM');

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final _searchTextController = TextEditingController();
  var _explanationsShowing = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            builder: (context) => ExplanationsAlert(
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

        return _ContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppBar(user: state.user),
              const SizedBox(height: 5),
              _SearchBar(
                controller: _searchTextController,
                onChanged: _searchTextChanged,
              ),
              const SizedBox(height: 5),
              if (state.tags.isNotEmpty)
                TagFilter(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  tags: state.sortedTags,
                  selectedTags: state.filter.tags,
                  onSelectTag: ({
                    required String tagName,
                    required bool isSelected,
                  }) {
                    final tags = isSelected
                        ? [...state.filter.tags, tagName]
                        : state.filter.tags.where((t) => t != tagName).toList();

                    context
                        .read<CalendarBloc>()
                        .add(CalendarTagFilterUpdate(tags: tags));
                  },
                ),
              const SizedBox(height: 40),
              if (screenWidth <= phoneBreakpoint) _MobileCalendar(state: state),
              if (screenWidth > phoneBreakpoint) _DesktopCalendar(state: state),
            ],
          ),
        );
      },
    );
  }

  void _searchTextChanged(BuildContext context, String text) {
    setState(() {});
    context.read<CalendarBloc>().add(
          CalendarSearchTextUpdate(
            searchText: text,
          ),
        );
  }
}

class _DesktopCalendar extends StatefulWidget {
  const _DesktopCalendar({
    required this.state,
  });

  final CalendarState state;

  @override
  State<_DesktopCalendar> createState() => _DesktopCalendarState();
}

class _DesktopCalendarState extends State<_DesktopCalendar> {
  int _selectedWeekIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedWeek = widget.state.filteredWeeks[_selectedWeekIndex];
    final startDate = _dateFormat.format(selectedWeek.days.first.date);
    final endDate = _dateFormat.format(selectedWeek.days.last.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WeekSelector(
          startDate: startDate,
          endDate: endDate,
          onPreviousTap: _selectedWeekIndex > 0
              ? () => setState(() => _selectedWeekIndex--)
              : null,
          onNextTap: _selectedWeekIndex < widget.state.weeks.length - 1
              ? () => setState(() => _selectedWeekIndex++)
              : null,
        ),
        const SizedBox(height: 20),
        _CalendarDays(
          selectedWeek: selectedWeek,
          sortedTags: widget.state.sortedTags,
          user: widget.state.user,
        ),
      ],
    );
  }
}

class _MobileCalendar extends StatefulWidget {
  const _MobileCalendar({
    required this.state,
  });

  final CalendarState state;

  @override
  State<_MobileCalendar> createState() => _MobileCalendarState();
}

class _MobileCalendarState extends State<_MobileCalendar> {
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final filteredWeeks = widget.state.filteredWeeks;
    final filteredDays =
        filteredWeeks.map((week) => week.days).expand((e) => e).toList();
    final selectedDay = filteredDays[_selectedDayIndex];
    final selectedWeekIndex = (_selectedDayIndex / 5).floor();
    final selectedWeek = filteredWeeks[selectedWeekIndex];
    final startDate = _dateFormat.format(selectedWeek.days.first.date);
    final endDate = _dateFormat.format(selectedWeek.days.last.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WeekSelector(
          startDate: startDate,
          endDate: endDate,
          onPreviousTap: _selectedDayIndex > 0
              ? () => setState(() => _selectedDayIndex--)
              : null,
          onNextTap: _selectedDayIndex < filteredDays.length - 1
              ? () => setState(() => _selectedDayIndex++)
              : null,
        ),
        const SizedBox(height: 20),
        _CalendarDay(
          day: selectedDay,
          isBestChoice: selectedWeek.bestChoices.contains(
            selectedDay.date.weekday,
          ),
          sortedTags: widget.state.sortedTags,
          user: widget.state.user,
        ),
      ],
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

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final void Function(BuildContext, String) onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      onChanged: (searchText) {
        onChanged(context, searchText);
      },
      hintText: 'Suche nach jambitees',
      controller: controller,
      leading: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(
          Icons.search,
        ),
      ),
      trailing: [
        if (controller.text.isNotEmpty)
          _ClearButton(
            onTap: () {
              controller.clear();
              onChanged(context, '');
            },
          ),
      ],
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
            const _SectionHeader(text: 'Meine Anwesenheit'),
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
            const _SectionHeader(
              text: 'Vorraussichtliche Anwesenheit der Kolleg*innen',
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

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.isBestChoice,
    required this.sortedTags,
    required this.user,
  });

  final CalendarDay day;
  final bool isBestChoice;
  final List<String> sortedTags;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(text: 'Meine Anwesenheit'),
            const SizedBox(height: 15),
            SizedBox(
              width: width,
              height: 170,
              child: CalendarDayOverview(
                day: day,
                tags: sortedTags,
                isBestChoice: isBestChoice,
                isColorBlind: user?.isColorBlind ?? false,
              ),
            ),
            const SizedBox(height: 20),
            const _SectionHeader(
              text: 'Vorraussichtliche Anwesenheit Kolleg*innen',
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: width,
              child: CalendarDayUsersList(
                day: day,
                tags: sortedTags,
              ),
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
    this.onNextTap,
    this.onPreviousTap,
  });

  final String startDate;
  final String endDate;
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
              child: const Text('Feedback'),
              onPressed: () => launchUrlString(Constants.feedbackUrl),
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

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(
        Icons.close,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: AppColors.frenchGrey,
          ),
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
