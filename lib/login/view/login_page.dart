import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/login/bloc/login_bloc.dart';
import 'package:jambu/repository/repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(
          userRepository: context.read<AuthRepository>(),
          firestoreRepository: context.read<FirestoreRepository>(),
        ),
        child: const LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginStatus = context.select((LoginBloc bloc) => bloc.state.status);
    if (loginStatus == LoginStatus.initial) {
      return const WelcomeView();
    } else if (loginStatus == LoginStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const ErrorView();
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Willkommen bei jambu.'),
          TextButton(
            onPressed: () {
              context.read<LoginBloc>().add(LoginRequested());
            },
            child: const Text('Anmelden'),
          ),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ein Fehler ist aufgetreten.'),
          TextButton(
            onPressed: () {
              context.read<LoginBloc>().add(LoginRequested());
            },
            child: const Text('Nochmal versuchen'),
          ),
        ],
      ),
    );
  }
}
