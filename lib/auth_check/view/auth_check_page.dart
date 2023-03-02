import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/auth_check/bloc/auth_check_bloc.dart';
import 'package:jambu/repository/repository.dart';

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => AuthCheckBloc(
          userRepository: context.read<UserRepository>(),
        )..add(AuthCheckRequested()),
        child: const AuthCheckView(),
      ),
    );
  }
}

class AuthCheckView extends StatelessWidget {
  const AuthCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCheckBloc, AuthCheckState>(
      listener: (context, state) {
        final authStatus = state.status;
        if (authStatus == AuthStatus.unauthenticated) {
          context.pushReplacement('/login');
        } else if (authStatus == AuthStatus.authenticated) {
          context.pushReplacement('/home');
        }
      },
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
