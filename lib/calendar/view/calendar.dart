import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';
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

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Column(
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
                  child: const Text('Logout'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: state.displayDates
                  .map(
                    (date) => _buildCalendarDay(
                      context,
                      date: date,
                      state: state,
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarDay(
    BuildContext context, {
    required DateTime date,
    required CalendarState state,
  }) {
    final filter = state.attendances.where(
      (a) => DateUtils.isSameDay(a.date, date),
    );
    final attendance = filter.isEmpty ? null : filter.first;
    final isUserAttending =
        state.userAttendances.where((d) => d.day == date.day).isNotEmpty;
    return _CalendarDay(
      date: date,
      attendance: attendance,
      isUserAttending: isUserAttending,
      onChanged: (value) => context.read<CalendarBloc>().add(
            CalendarAttendanceUpdate(
              date: date,
              isAttending: !isUserAttending,
            ),
          ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    required this.onChanged,
    this.attendance,
    this.isUserAttending = false,
  });

  final DateTime date;
  final Attendance? attendance;
  final bool isUserAttending;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(
          value: isUserAttending,
          onChanged: onChanged,
        ),
        Text(date.weekdayString),
        ...attendance?.users.map(Text.new) ?? [],
      ],
    );
  }
}
