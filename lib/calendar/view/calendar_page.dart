import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/calendar/bloc/calendar_bloc.dart';
import 'package:jambu/calendar/repository/repository.dart';
import 'package:jambu/calendar/view/calendar_view.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

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
