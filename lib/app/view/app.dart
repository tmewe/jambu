import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/app/app.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/repository/repository.dart';

class App extends StatelessWidget {
  const App({
    required AuthRepository userRepository,
    required MSGraphRepository msGraphRepository,
    required FirestoreRepository firestoreRepository,
    super.key,
  })  : _userRepository = userRepository,
        _msGraphRepository = msGraphRepository,
        _firestoreRepository = firestoreRepository;

  final AuthRepository _userRepository;
  final MSGraphRepository _msGraphRepository;
  final FirestoreRepository _firestoreRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _msGraphRepository),
        RepositoryProvider.value(value: _firestoreRepository),
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
