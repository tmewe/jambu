import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/home/home.dart';
import 'package:jambu/login/bloc/login_bloc.dart';
import 'package:jambu/repository/repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(
          userRepository: context.read<UserRepository>(),
        )..add(LoginRequested()),
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
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<HomePage>(
              builder: (_) => const HomePage(),
            ),
          );
        }
      },
      child: Center(
        child: (loginStatus == LoginStatus.initial ||
                loginStatus == LoginStatus.loading)
            ? const CircularProgressIndicator()
            : const Text(''),
      ),
    );
  }
}
