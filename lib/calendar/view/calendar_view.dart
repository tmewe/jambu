import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/app_ui/app_ui.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/widgets/tag_filter.dart';
import 'package:jambu/calendar/widgets/widgets.dart';
import 'package:jambu/repository/repository.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final searchTextController = TextEditingController();

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state.status != CalendarStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Align(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maElementWidth),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context
                                  .read<CalendarBloc>()
                                  .add(CalendarRequested());
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AuthRepository>().logout();
                            },
                            child: const Text('Abmelden'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.goNamed('playground');
                            },
                            child: const Text('Playground'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SearchBar(
                        controller: searchTextController,
                        onChanged: (searchText) {
                          setState(() {});
                          context.read<CalendarBloc>().add(
                                CalendarSearchTextUpdate(
                                  searchText: searchText,
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: 10),
                      TagFilter(
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
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.read<CalendarBloc>().add(
                                        CalendarGoToWeek(
                                          weekNumber: state.selectedWeek - 1,
                                        ),
                                      );
                                },
                                icon: const Icon(Icons.arrow_back_ios),
                              ),
                              ...state.filteredWeeks[state.selectedWeek].days
                                  .map(
                                (day) {
                                  return CalendarDayColumn(
                                    day: day,
                                    tags: state.sortedTags,
                                    width: (constraints.maxWidth - 100) / 5,
                                  );
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<CalendarBloc>().add(
                                        CalendarGoToWeek(
                                          weekNumber: state.selectedWeek + 1,
                                        ),
                                      );
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
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
}
