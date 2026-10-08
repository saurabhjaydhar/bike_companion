import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/notification_service.dart';
import '../../l10n/l10n.dart';
import 'app_snack.dart';

const _askedKey = 'reminders_permission_asked';

/// Asks for notification permission the first time the user saves a date
/// worth a reminder, with one sentence on why. Asks once; after that the
/// dashboard's "Reminders are off" banner offers it again.
Future<void> askReminderPermissionOnce(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_askedKey) ?? false) return;
  if (await NotificationService.isPermitted()) {
    await prefs.setBool(_askedKey, true);
    return;
  }
  if (!context.mounted) return;

  final l = context.l10n;
  final turnOn = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.notifications_active_outlined),
      title: Text(l.remindersPermissionTitle),
      content: Text(l.remindersPermissionBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(l.remindersNotNow),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(l.remindersTurnOn),
        ),
      ],
    ),
  );
  await prefs.setBool(_askedKey, true);
  if (turnOn ?? false) await NotificationService.requestPermission();
}

/// From the "Reminders are off" banner: shows the system prompt again, and
/// when the system won't show it any more, explains where to turn
/// notifications on. Returns whether they're on now.
Future<bool> turnOnReminders(BuildContext context) async {
  final granted = await NotificationService.requestPermission();
  if (!granted && context.mounted) {
    showAppSnack(context, context.l10n.remindersEnableInSettings);
  }
  return granted;
}
