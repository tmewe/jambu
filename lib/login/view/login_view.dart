import 'package:app_ui/app_ui.dart';
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
        return const _LoginContainer(child: _LoadingView());
      case LoginStatus.loggedOut:
        return const _LoginContainer(child: _WelcomeView());
      case LoginStatus.failure:
        return const _LoginContainer(child: _ErrorView());
    }
  }
}

class _LoginContainer extends StatelessWidget {
  const _LoginContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: AppColors.seasaltGrey.withOpacity(0.8),
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Willkommen bei jambu',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () {
            context.read<LoginBloc>().add(LoginRequested());
          },
          child: const Text('Anmelden'),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 30),
        SelectableText(
          'Falls du kein Popup sehen solltest, '
          'überprüfe bitte ob dein Browser das Popup blockiert. '
          'Ggf. muss die Seite nochmal neu geladen werden.',
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Ein Fehler ist aufgetreten.'),
        const SizedBox(height: 20),
        FilledButton.tonal(
          onPressed: () => context.read<LoginBloc>().add(LoginRequested()),
          child: const Text('Nochmal versuchen'),
        ),
      ],
    );
  }
}
