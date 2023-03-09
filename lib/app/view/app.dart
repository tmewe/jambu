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
    super.key,
  })  : _authRepository = authRepository,
        _msGraphRepository = msGraphRepository,
        _firestoreRepository = firestoreRepository,
        _userRepository = userRespository;

  final AuthRepository _authRepository;
  final MSGraphRepository _msGraphRepository;
  final FirestoreRepository _firestoreRepository;
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _msGraphRepository),
        RepositoryProvider.value(value: _firestoreRepository),
        RepositoryProvider.value(value: _userRepository),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final userStream = context.read<AuthRepository>().userStream;
    return MaterialApp.router(
      routerConfig: getRouter(userStream: userStream),
    );
  }
}
