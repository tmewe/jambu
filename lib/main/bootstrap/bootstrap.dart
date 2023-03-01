import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/firebase_options.dart';
import 'package:jambu/main/bootstrap/app_bloc_observer.dart';

typedef AppBuilder = Future<Widget> Function(
  FirebaseMessaging firebaseMessaging,
  FirebaseAuth firebaseAuth,
);

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();

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
      log('An error occured', error: error, stackTrace: stacktrace);
    },
  );
}
