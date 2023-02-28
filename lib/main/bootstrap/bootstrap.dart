import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jambu/firebase_options.dart';

typedef AppBuilder = Future<Widget> Function(
  FirebaseMessaging firebaseMessaging,
  FirebaseAuth firebaseAuth,
);

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await runZonedGuarded<Future<void>>(
    () async {
      runApp(
        await builder(
          FirebaseMessaging.instance,
          FirebaseAuth.instance,
        ),
      );
    },
    (error, stacktrace) {
      print(error);
    },
  );
}
