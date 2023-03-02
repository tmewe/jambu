import 'package:go_router/go_router.dart';
import 'package:jambu/auth_check/auth_check.dart';
import 'package:jambu/login/login.dart';
import 'package:jambu/playground/playground.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthCheckPage(),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: PlaygroundPage(),
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
