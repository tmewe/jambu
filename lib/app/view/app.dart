import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/app/app.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/calendar.dart';
import 'package:jambu/ms_graph/ms_graph.dart';
import 'package:jambu/repository/repository.dart';

class App extends StatelessWidget {
  const App({
    required AuthRepository authRepository,
    required MSGraphRepository msGraphRepository,
    required FirestoreRepository firestoreRepository,
    required UserRepository userRespository,
    required CalendarRepository calendarRepository,
    required PhotoStorageRepository photoStorageRepository,
    required NotificationsRepository notificationsRepository,
    super.key,
  })  : _authRepository = authRepository,
        _msGraphRepository = msGraphRepository,
        _firestoreRepository = firestoreRepository,
        _userRepository = userRespository,
        _calendarRepository = calendarRepository,
        _photoStorageRepository = photoStorageRepository,
        _notificationsRepository = notificationsRepository;

  final AuthRepository _authRepository;
  final MSGraphRepository _msGraphRepository;
  final FirestoreRepository _firestoreRepository;
  final UserRepository _userRepository;
  final CalendarRepository _calendarRepository;
  final PhotoStorageRepository _photoStorageRepository;
  final NotificationsRepository _notificationsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _msGraphRepository),
        RepositoryProvider.value(value: _firestoreRepository),
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _calendarRepository),
        RepositoryProvider.value(value: _photoStorageRepository),
        RepositoryProvider.value(value: _notificationsRepository),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<UserRepository>().currentUserStream;
    return MaterialApp.router(
      theme: const AppTheme().themeData,
      debugShowCheckedModeBanner: false,
      routerConfig: getRouter(userStream: authState),
    );
  }
}
