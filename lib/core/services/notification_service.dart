import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../data/models/document.dart';
import '../../l10n/l10n.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'bike_companion';
  static const _channelName = 'Bike Companion Alerts';
  static const _channelDesc = 'Document expiry and service reminders';

  // Notification ID ranges:
  //   0–9999   : 30-day document warnings
  // 10000–19999: 7-day document warnings
  // 20000–29999: 1-day document warnings
  // 50000+     : service / ad-hoc alerts

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    } catch (_) {
      // fallback to UTC if timezone lookup fails
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: iosSettings),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.high,
        ));

    // Request permission on Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Called whenever the documents list changes — reschedules all doc reminders.
  static Future<void> scheduleDocumentReminders(
      List<BikeDocument> docs) async {
    // Cancel old doc notifications
    for (int i = 0; i < 30000; i += 10000) {
      // only cancel the 3 bands; cheap because they're individually keyed
    }
    // Instead, cancel per-doc
    for (final doc in docs) {
      await cancelDocumentReminders(doc.id);
    }

    final l = await loadAppLocalizations();
    for (final doc in docs) {
      if (doc.expiryDate == null) continue;
      await _scheduleForDoc(l, doc, threshold: 30);
      await _scheduleForDoc(l, doc, threshold: 7);
      await _scheduleForDoc(l, doc, threshold: 1);
    }
  }

  static Future<void> _scheduleForDoc(AppLocalizations l, BikeDocument doc,
      {required int threshold}) async {
    final expiry = doc.expiryDate!;
    final fireDate =
        expiry.subtract(Duration(days: threshold));
    final now = DateTime.now();

    // Already past the fire date — show immediately if still within validity
    if (fireDate.isBefore(now) && expiry.isAfter(now)) {
      final daysSince = now.difference(fireDate).inDays;
      if (daysSince <= 1) {
        await _showNow(
          id: _docId(doc.id, threshold),
          title: _docTitle(l, threshold),
          body: l.notifDocBody(doc.title, threshold),
        );
      }
      return;
    }

    if (fireDate.isBefore(now)) return; // already expired + past fire date

    await _scheduleNotification(
      id: _docId(doc.id, threshold),
      title: _docTitle(l, threshold),
      body: l.notifDocBody(doc.title, threshold),
      scheduledDate: fireDate,
    );
  }

  static Future<void> cancelDocumentReminders(String docId) async {
    await _plugin.cancel(_docId(docId, 30));
    await _plugin.cancel(_docId(docId, 7));
    await _plugin.cancel(_docId(docId, 1));
  }

  static Future<void> showServiceAlert({
    required String bikeName,
    required String serviceType,
  }) async {
    final l = await loadAppLocalizations();
    await _showNow(
      id: 50000 + serviceType.hashCode.abs() % 1000,
      title: l.notifServiceOverdueTitle(bikeName),
      body: l.notifServiceOverdueBody(serviceType),
    );
  }

  static Future<void> cancelAll() async => _plugin.cancelAll();

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  static int _docId(String docId, int threshold) {
    final band = switch (threshold) {
      30 => 0,
      7 => 10000,
      _ => 20000,
    };
    return band + docId.hashCode.abs() % 9000;
  }

  static String _docTitle(AppLocalizations l, int threshold) =>
      threshold == 1 ? l.notifDocTomorrowTitle : l.notifDocTitle(threshold);

  static const _notifDetails = NotificationDetails(
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

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
      if (tzDate.isBefore(tz.TZDateTime.now(tz.local))) return;

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        _notifDetails,
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'doc_reminder',
      );
    } catch (_) {
      // Silently ignore scheduling failures (e.g., permission denied)
    }
  }

  static Future<void> _showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      await _plugin.show(id, title, body, _notifDetails);
    } catch (_) {}
  }
}
