import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsRespository {
  NotificationsRespository({
    required FirebaseMessaging firebaseMessaging,
  }) : _firebaseMessaging = firebaseMessaging;

  final FirebaseMessaging _firebaseMessaging;

  // TODO(tim): Refactor
  Future<void> requestNotifications() async {
    final notificationSettings =
        await _firebaseMessaging.getNotificationSettings();
    final status = notificationSettings.authorizationStatus;

    if (status == AuthorizationStatus.notDetermined) {
      await FirebaseMessaging.instance.requestPermission();
      final fcmToken = await _firebaseMessaging.getToken(
        vapidKey:
            '''BDwDEXNpZUq9IJQ60LNTt3At9ctSWMBiEo5BMXzB9X2VojyfM0En84zNMr328DhLhruGVJQPCjo2lTJ3YCZhGoY''',
      );
      debugPrint(fcmToken);
    }
  }
}
