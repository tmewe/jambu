import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/app/router/gorouter_refresh_stream.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/home/home.dart';
import 'package:jambu/login/login.dart';
import 'package:jambu/logout/logout.dart';
import 'package:jambu/model/model.dart';

GoRouter getRouter({
  required Stream<User?> userStream,
}) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(userStream),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomePage(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: '/logout',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LogoutPage(),
        ),
      ),
    ],
  );
}

String? _redirect(BuildContext context, GoRouterState state) {
  final user = context.read<UserRepository>().currentUser;
  final isLoggedIn = user != null;
  final isLoggingIn = state.subloc == '/login';

  if (!isLoggedIn && !isLoggingIn) {
    return '/login';
  } else if (isLoggedIn && isLoggingIn) {
    return '/';
  }
  return null;
}
