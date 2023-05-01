import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/app/router/gorouter_refresh_stream.dart';
import 'package:jambu/calendar/calendar.dart';
import 'package:jambu/login/login.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/onboarding/onboarding.dart';
import 'package:jambu/profile/profile.dart';
import 'package:jambu/user/user.dart';

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
          child: CalendarPage(),
        ),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) {
              final extra = state.extra;
              final user = extra is User ? extra : null;
              return user != null
                  ? ProfilePage(user: user)
                  : const _ErrorPage();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingPage(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginPage(),
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
  } else if (isLoggedIn && !user.onboardingCompleted) {
    return '/onboarding';
  }
  return state.subloc;
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Error'),
      ),
    );
  }
}
