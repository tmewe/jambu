import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jambu/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseUIAuth.configureProviders([
  //   EmailAuthProvider(),
  // ]);

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
      vapidKey:
          'BDwDEXNpZUq9IJQ60LNTt3At9ctSWMBiEo5BMXzB9X2VojyfM0En84zNMr328DhLhruGVJQPCjo2lTJ3YCZhGoY',
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
        child: Column(
          children: [
            SelectableText(fcmToken ?? 'No token'),
            TextButton(
              onPressed: () async {
                final msProvider = MicrosoftAuthProvider();

                // msProvider.addScope('profile');
                // msProvider.addScope('user.read');
                // msProvider.addScope('user.readwrite');

                msProvider.setCustomParameters({
                  'tenant': 'e6dbe219-77ef-4b6a-af83-f9de7de08923',
                  // 'client_id': '236defaf-9f15-425a-a578-24836a9a3abd',
                  // 'redirect_uri':
                  //     'https://jambu-100d1.firebaseapp.com/__/auth/handler',
                });
                try {
                  final user =
                      await FirebaseAuth.instance.signInWithPopup(msProvider);
                  print(user);
                } on FirebaseAuthException catch (e) {
                  print(e.message);
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoggedInPage extends StatelessWidget {
  const LoggedInPage({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoggedIn ? 'Yeah' : 'Meeh'),
      ),
    );
  }
}
