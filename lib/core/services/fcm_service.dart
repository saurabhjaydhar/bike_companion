import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmService {
  static final _fcm = FirebaseMessaging.instance;

  static const _androidChannel = AndroidNotificationChannel(
    'fcm_high_importance',
    'Push Notifications',
    description: 'Bike Companion push notifications',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Create the Android notification channel for foreground FCM messages.
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  static Future<String?> getToken() => _fcm.getToken();

  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.show(
      message.hashCode,
      notification.title ?? 'Bike Companion',
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: _androidChannel.importance,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
