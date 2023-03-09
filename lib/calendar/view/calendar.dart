import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc(
        firestoreRepository: context.read<FirestoreRepository>(),
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
        return Row(
          children: state.displayDates.map(
            (date) {
              final filter =
                  state.attendances.where((a) => a.date.day == date.day);
              return _CalendarDay(
                date: date,
                attendance: filter.isEmpty ? null : filter.first,
              );
            },
          ).toList(),
        );
      },
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    this.attendance,
  });

  final DateTime date;
  final Attendance? attendance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(date.weekdayString),
        ...attendance?.users.map(Text.new) ?? [],
      ],
    );
  }
}
