import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jambu/app_ui/app_ui.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/widgets/tag_filter.dart';
import 'package:jambu/calendar/widgets/widgets.dart';
import 'package:jambu/repository/repository.dart';

final _dateFormat = DateFormat('dd.MM');

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final _searchTextController = TextEditingController();
  int _selectedWeekIndex = 0;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state.status != CalendarStatus.success) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final selectedWeek = state.filteredWeeks[_selectedWeekIndex];
        final startDate = _dateFormat.format(selectedWeek.days.first.date);
        final endDate = _dateFormat.format(selectedWeek.days.last.date);

        return Scaffold(
          body: SingleChildScrollView(
            child: Align(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxElementWidth),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'jambu',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<CalendarBloc>()
                                  .add(CalendarRequested());
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                          MenuAnchor(
                            alignmentOffset: const Offset(-62, 0),
                            menuChildren: [
                              MenuItemButton(
                                child: const Text('Mein Profil'),
                                onPressed: () {
                                  final router = GoRouter.of(context);
                                  router
                                    ..goNamed('profile', extra: state.user)
                                    ..addListener(
                                      () => routerListener(
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
                                onPressed: () =>
                                    context.read<AuthRepository>().logout(),
                              ),
                            ],
                            builder: (context, controller, child) => IconButton(
                              onPressed: () => controller.isOpen
                                  ? controller.close()
                                  : controller.open(),
                              icon: CircleAvatar(
                                foregroundImage: NetworkImage(
                                  state.user?.imageUrl ?? '',
                                ),
                                child: Text(
                                  state.user?.name.characters.first ?? '',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                : state.filter.tags
                                    .where((t) => t != tag)
                                    .toList();

                            context
                                .read<CalendarBloc>()
                                .add(CalendarTagFilterUpdate(tags: tags));
                          },
                        ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Text(
                            '$startDate - $endDate',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: _selectedWeekIndex > 0
                                ? () => setState(() => _selectedWeekIndex--)
                                : null,
                            icon: const Icon(Icons.chevron_left),
                          ),
                          IconButton(
                            onPressed:
                                _selectedWeekIndex < state.weeks.length - 1
                                    ? () => setState(() => _selectedWeekIndex++)
                                    : null,
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: selectedWeek.days.map(
                              (day) {
                                return CalendarDayColumn(
                                  day: day,
                                  tags: state.sortedTags,
                                  isBestChoice: selectedWeek.bestChoices
                                      .contains(day.date.weekday),
                                  width: (constraints.maxWidth - 100) / 5,
                                );
                              },
                            ).toList(),
                          );
                        },
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

  void routerListener({
    required GoRouter router,
    required BuildContext context,
  }) {
    if (!GoRouter.of(context).location.contains('profile')) {
      context.read<CalendarBloc>().add(CalendarRefresh());
    }
    router.removeListener(
      () => routerListener(router: router, context: context),
    );
  }
}
