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
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
        )..add(LoginInitialCheck()),
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
    if (loginStatus == LoginStatus.loggedOut) {
      return const _WelcomeView();
    } else if (loginStatus == LoginStatus.failure) {
      return const _ErrorView();
    }
    return const _LoadingView();
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Willkommen bei jambu'),
          const SizedBox(height: 10),
          FilledButton(
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

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 30),
            SelectableText(
              'Falls du kein Popup sehen solltest, '
              'überprüfe bitte ob dein Browser das Popup blockiert. '
              'Ggf. muss die Seite nochmal neu geladen werden.',
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

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
