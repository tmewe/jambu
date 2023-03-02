import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/app/app.dart';
import 'package:jambu/ms_graph/repository/respository.dart';
import 'package:jambu/repository/repository.dart';

class App extends StatelessWidget {
  const App({
    required UserRepository userRepository,
    required MSGraphRepository msGraphRepository,
    super.key,
  })  : _userRepository = userRepository,
        _msGraphRepository = msGraphRepository;

  final UserRepository _userRepository;
  final MSGraphRepository _msGraphRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _msGraphRepository),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
    );
  }
}
