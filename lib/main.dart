import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jambu/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SignInScreen(
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            final loggedIn = !state.user!.emailVerified;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => LoggedInPage(
                  isLoggedIn: loggedIn,
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class LoggedInPage extends StatelessWidget {
  final bool isLoggedIn;

  const LoggedInPage({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoggedIn ? 'Yeah' : 'Meeh'),
      ),
    );
  }
}
