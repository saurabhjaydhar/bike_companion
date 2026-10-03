import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Notification ID for [key] (e.g. `insurance:{vehicleId}::20260601:30`):
/// a 31-bit FNV-1a hash. Unlike [String.hashCode] it's the same on every
/// platform and app version, so a reminder can always be found again to
/// cancel or replace it.
int notificationId(String key) {
  var hash = 0x811c9dc5;
  for (final unit in key.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xFFFFFFFF;
  }
  return hash & 0x7FFFFFFF;
}

/// Thin wrapper around the local notifications plugin. What to schedule and
/// when is decided by ReminderService.
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'bike_companion';
  static const _channelName = 'Reminders';
  static const _channelDesc = 'Expiry and service reminders';

  /// Payloads of notifications scheduled by older app versions.
  static const _legacyPayloads = {'doc_reminder'};

  static final _taps = StreamController<String>.broadcast();

  /// Payloads of notifications the user taps while the app is running.
  static Stream<String> get taps => _taps.stream;

  /// Payload of the notification that launched the app, if any. Read once.
  static String? takeLaunchPayload() {
    final payload = _launchPayload;
    _launchPayload = null;
    return payload;
  }

  static String? _launchPayload;

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    } catch (_) {
      // fallback to UTC if timezone lookup fails
    }

    // Permission is asked later, when the user first saves a date worth a
    // reminder — not on first launch.
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) _taps.add(payload);
      },
    );

    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _launchPayload = launch!.notificationResponse?.payload;
    }

    await _android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      ),
    );
  }

  static AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  static IOSFlutterLocalNotificationsPlugin? get _ios =>
      _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  /// Whether the app may show notifications.
  static Future<bool> isPermitted() async {
    final android = _android;
    if (android != null) return await android.areNotificationsEnabled() ?? true;
    final ios = _ios;
    if (ios != null) return (await ios.checkPermissions())?.isEnabled ?? false;
    return true;
  }

  /// Shows the system permission prompt. Returns whether it's granted.
  static Future<bool> requestPermission() async {
    final android = _android;
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _ios;
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Schedules (or replaces) notification [id] at [at], local time.
  static Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required String payload,
  }) async {
    try {
      final when = tz.TZDateTime.from(at, tz.local);
      if (when.isBefore(tz.TZDateTime.now(tz.local))) return;
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        when,
        _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Notifications: could not schedule $id: $e');
    }
  }

  static Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await _plugin.show(id, title, body, _details, payload: payload);
    } catch (e) {
      debugPrint('Notifications: could not show $id: $e');
    }
  }

  static Future<void> cancel(int id) => _plugin.cancel(id);

  /// IDs of scheduled reminders whose payload starts with [payloadPrefix],
  /// including ones left by older app versions.
  static Future<Set<int>> scheduledIds(String payloadPrefix) async {
    final pending = await _plugin.pendingNotificationRequests();
    return {
      for (final p in pending)
        if ((p.payload?.startsWith(payloadPrefix) ?? false) ||
            _legacyPayloads.contains(p.payload))
          p.id,
    };
  }

  static Future<void> cancelAll() => _plugin.cancelAll();
}
