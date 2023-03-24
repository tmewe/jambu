import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jambu/app_ui/app_ui.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/widgets/widgets.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/repository/repository.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc(
        calendarRepository: context.read<CalendarRepository>(),
      )..add(CalendarRequested()),
      child: const CalendarView(),
    );
  }
}

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
          return const CircularProgressIndicator();
        }
        return Align(
          child: Container(
            constraints: const BoxConstraints(maxWidth: maElementWidth),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<CalendarBloc>().add(CalendarRequested());
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
                      context
                          .read<CalendarBloc>()
                          .add(CalendarFilterUpdate(searchText: searchText));
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
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
                      ...state.weeks[state.selectedWeek].days.map(
                        (day) {
                          return _CalendarDay(
                            day: day,
                            onChanged: (value) {
                              context.read<CalendarBloc>().add(
                                    CalendarAttendanceUpdate(
                                      date: day.date,
                                      isAttending: value,
                                    ),
                                  );
                            },
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class _CalendarDay extends StatefulWidget {
  _CalendarDay({
    required this.day,
    required this.onChanged,
  }) {
    _isOn = day.isUserAttending;
  }

  final CalendarDay day;
  final ValueChanged<bool> onChanged;
  var _isOn = false;

  @override
  State<_CalendarDay> createState() => _CalendarDayState();
}

class _CalendarDayState extends State<_CalendarDay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(
          value: widget._isOn,
          onChanged: (value) {
            setState(() => widget._isOn = value);
            widget.onChanged(value);
          },
        ),
        Text(widget.day.date.weekdayString),
        Text(DateFormat('dd').format(widget.day.date)),
        ...widget.day.users.map((user) => CalendarItem(user: user)),
      ],
    );
  }
}
