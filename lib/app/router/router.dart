import 'package:go_router/go_router.dart';
import 'package:jambu/auth_check/auth_check.dart';
import 'package:jambu/home/home.dart';
import 'package:jambu/login/login.dart';

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
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
