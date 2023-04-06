import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jambu/firebase_options.dart';
import 'package:jambu/main/bootstrap/app_bloc_observer.dart';

typedef AppBuilder = Future<Widget> Function(
  FirebaseMessaging firebaseMessaging,
  FirebaseAuth firebaseAuth,
  FirebaseFirestore firebaseFirestore,
  FirebaseStorage firebaseStorage,
);

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Bloc.observer = AppBlocObserver();

  await runZonedGuarded<Future<void>>(
    () async {
      runApp(
        await builder(
          FirebaseMessaging.instance,
          FirebaseAuth.instance,
          FirebaseFirestore.instance,
          FirebaseStorage.instance,
        ),
      );
    },
    (error, stacktrace) {
      debugPrint('An error occured: $error');
    },
  );
}
