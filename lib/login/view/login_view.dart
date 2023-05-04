import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/login/bloc/login_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginStatus = context.select((LoginBloc bloc) => bloc.state.status);
    switch (loginStatus) {
      case LoginStatus.loggedIn:
      case LoginStatus.unknown:
        return const SizedBox.shrink();
      case LoginStatus.loading:
        return const _LoadingView();
      case LoginStatus.loggedOut:
        return const _WelcomeView();
      case LoginStatus.failure:
        return const _ErrorView();
    }
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
          const SizedBox(height: 10),
          FilledButton.tonal(
            onPressed: () => context.read<LoginBloc>().add(LoginRequested()),
            child: const Text('Nochmal versuchen'),
          ),
        ],
      ),
    );
  }
}
