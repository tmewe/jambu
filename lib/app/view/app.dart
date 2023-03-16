import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/app/app.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/repository/repository.dart';

class App extends StatelessWidget {
  const App({
    required AuthRepository authRepository,
    required MSGraphRepository msGraphRepository,
    required FirestoreRepository firestoreRepository,
    required UserRepository userRespository,
    required CalendarRepository calendarRepository,
    required PhotoStorageRepository photoStorageRepository,
    super.key,
  })  : _authRepository = authRepository,
        _msGraphRepository = msGraphRepository,
        _firestoreRepository = firestoreRepository,
        _userRepository = userRespository,
        _calendarRepository = calendarRepository,
        _photoStorageRepository = photoStorageRepository;

  final AuthRepository _authRepository;
  final MSGraphRepository _msGraphRepository;
  final FirestoreRepository _firestoreRepository;
  final UserRepository _userRepository;
  final CalendarRepository _calendarRepository;
  final PhotoStorageRepository _photoStorageRepository;

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
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final userStream = context.read<UserRepository>().currentUserStream;
    return MaterialApp.router(
      theme: ThemeData(useMaterial3: true),
      routerConfig: getRouter(userStream: userStream),
    );
  }
}
