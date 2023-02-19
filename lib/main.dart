import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  final messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  String? fcmToken;
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    fcmToken = await messaging.getToken(
      vapidKey: 'BDwDEXNpZUq9IJQ60LNTt3At9ctSWMBiEo5BMXzB9X2VojyfM0En84zNMr328DhLhruGVJQPCjo2lTJ3YCZhGoY',
    );
    print(fcmToken);
  }

  runApp(MyApp(fcmToken: fcmToken));
}

class MyApp extends StatelessWidget {
  const MyApp({this.fcmToken, super.key});

  final String? fcmToken;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jambu',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(fcmToken: fcmToken),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({this.fcmToken, super.key});

  final String? fcmToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SelectableText(fcmToken ?? 'No token'),
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
