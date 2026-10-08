import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/restore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';
import 'app_snack.dart';
import 'clay_icon.dart';
import 'hud_panel.dart';

/// Links a guest account to Google so the garage is backed up. Returns true
/// once linked. Shows its own success or error message.
Future<bool> backUpWithGoogle(BuildContext context) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  try {
    final result = await getIt<AuthService>().linkWithGoogle();
    if (result == null) return false; // cancelled
    final user = result.credential.user!;
    getIt<FirestoreService>()
        .saveUserProfile(user.uid, name: user.displayName, email: user.email)
        .ignore();
    // Signed into an existing account: bring its data onto this device too.
    if (result.switched) {
      await getIt<RestoreService>().restoreIfNeeded(user.uid);
    }
    HapticFeedback.mediumImpact();
    messenger.showToast(l.backupDone, tone: SnackTone.success);
    return true;
  } catch (e) {
    messenger.showToast(l.authSignInFailed('$e'), tone: SnackTone.error);
    return false;
  }
}

/// Days a dismissed backup nudge stays hidden.
const backupNudgeSnoozeDays = 7;

/// Whether to show the backup nudge: only for guests, and not while it is
/// snoozed.
bool shouldShowBackupNudge({
  required bool isGuest,
  DateTime? dismissedAt,
  required DateTime now,
}) =>
    isGuest &&
    (dismissedAt == null ||
        now.difference(dismissedAt).inDays >= backupNudgeSnoozeDays);

/// "Back up your garage" card for guests, shown on the dashboard.
class BackupNudgeCard extends StatefulWidget {
  const BackupNudgeCard({super.key});

  @override
  State<BackupNudgeCard> createState() => _BackupNudgeCardState();
}

class _BackupNudgeCardState extends State<BackupNudgeCard> {
  bool _visible = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(SharedPrefKeys.backupNudgeDismissedAt);
    final show = shouldShowBackupNudge(
      isGuest: getIt<AuthService>().isAnonymous,
      dismissedAt:
          ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms),
      now: DateTime.now(),
    );
    if (mounted && show != _visible) setState(() => _visible = show);
  }

  Future<void> _dismiss() async {
    setState(() => _visible = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPrefKeys.backupNudgeDismissedAt,
        DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _backUp() async {
    setState(() => _busy = true);
    final linked = await backUpWithGoogle(context);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (linked) _visible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      child: HudPanel(
        onTap: _busy ? null : _backUp,
        child: Row(
          children: [
            const ClayIcon(
                icon: Icons.cloud_upload_rounded, color: AppColors.accentInk),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.backupTitle.toUpperCase(),
                      style: AppTextStyles.label
                          .copyWith(color: textPrimary, fontSize: 14)),
                  Text(l.backupBody,
                      style: AppTextStyles.caption
                          .copyWith(color: textSecondary)),
                ],
              ),
            ),
            if (_busy)
              const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
            else
              IconButton(
                tooltip: l.backupLater,
                icon: Icon(Icons.close_rounded, color: textSecondary),
                onPressed: _dismiss,
              ),
          ],
        ),
      ),
    );
  }
}
