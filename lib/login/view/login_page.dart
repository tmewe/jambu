import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/login/bloc/login_bloc.dart';
import 'package:jambu/login/view/login_view.dart';
import 'package:jambu/user/user.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
        ),
        child: const LoginView(),
      ),
    );
  }
}
