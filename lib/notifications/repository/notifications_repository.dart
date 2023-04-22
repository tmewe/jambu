import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jambu/constants.dart';

class NotificationsRepository {
  NotificationsRepository({
    required FirebaseMessaging firebaseMessaging,
  }) : _firebaseMessaging = firebaseMessaging;

  final FirebaseMessaging _firebaseMessaging;

  Future<void> requestNotifications() async {
    final notificationSettings =
        await _firebaseMessaging.getNotificationSettings();
    var status = notificationSettings.authorizationStatus;

    if (status == AuthorizationStatus.notDetermined) {
      final requestedSettings =
          await FirebaseMessaging.instance.requestPermission();
      status = requestedSettings.authorizationStatus;
    }

    if (status == AuthorizationStatus.authorized) {
      final fcmToken = await _firebaseMessaging.getToken(
        vapidKey: Constants.vapidKey,
      );
      debugPrint('FCM Token: $fcmToken');
    }
  }
}
