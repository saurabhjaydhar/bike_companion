import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import 'clay_icon.dart';

enum SnackTone { info, success, error }

/// Shows a Garajo toast: a floating carbon capsule that matches the nav bar,
/// with a glowing tone stripe, an icon tile and an optional action. Reads the
/// same in light and dark themes.
extension AppSnackX on ScaffoldMessengerState {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, {
    SnackTone tone = SnackTone.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    hideCurrentSnackBar();
    return showSnackBar(SnackBar(
      content: AppSnack(
        message: message,
        tone: tone,
        actionLabel: actionLabel,
        onAction: onAction == null
            ? null
            : () {
                hideCurrentSnackBar(reason: SnackBarClosedReason.action);
                onAction();
              },
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
    ));
  }
}

/// Shorthand for `ScaffoldMessenger.of(context).showToast(...)`.
void showAppSnack(
  BuildContext context,
  String message, {
  SnackTone tone = SnackTone.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showToast(
    message,
    tone: tone,
    actionLabel: actionLabel,
    onAction: onAction,
    duration: duration,
  );
}

/// The toast body. Carbon in light mode, night panel in dark — the tone
/// colours are the neon set in both, since the capsule is dark either way.
class AppSnack extends StatelessWidget {
  final String message;
  final SnackTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppSnack({
    super.key,
    required this.message,
    this.tone = SnackTone.info,
    this.actionLabel,
    this.onAction,
  });

  (Color, IconData) get _tone => switch (tone) {
        SnackTone.info => (AppColors.accent, Icons.bolt_rounded),
        SnackTone.success => (AppColors.successDark, Icons.check_rounded),
        SnackTone.error => (AppColors.dangerDark, Icons.priority_high_rounded),
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (color, icon) = _tone;
    final surface = isDark ? AppColors.surfaceVariantDark : AppColors.carbon;
    final shape = BorderRadius.circular(AppRadius.large - 4);
    final animate = !MediaQuery.disableAnimationsOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: [
          ...AppShadows.raised(isDark),
          AppShadows.glow(color, true),
        ],
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: shape,
            border: Border.all(
              color: Color.alphaBlend(
                color.withValues(alpha: 0.35),
                isDark ? AppColors.borderDark : AppColors.carbonEdge,
              ),
            ),
            gradient: LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: [
                Color.alphaBlend(color.withValues(alpha: 0.14), surface),
                surface,
              ],
              stops: const [0, 0.45],
            ),
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: animate ? 0 : 1, end: 1),
            duration: AppDuration.slow,
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Stack(
              children: [
                // Glowing tone stripe that "charges" up on entry.
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    child: Container(
                      width: 3,
                      height: 34 * t,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadiusDirectional.horizontal(
                                end: Radius.circular(2))
                            .resolve(Directionality.of(context)),
                        boxShadow: [BoxShadow(color: color, blurRadius: 10)],
                      ),
                    ),
                  ),
                ),
                child!,
              ],
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                AppSpacing.lg,
                AppSpacing.md,
                onAction == null ? AppSpacing.lg : AppSpacing.xs,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(brightness: Brightness.dark),
                    child: ClayIcon(icon: icon, color: color, size: 32),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textPrimaryDark),
                    ),
                  ),
                  if (onAction != null && actionLabel != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        foregroundColor: color,
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md),
                        textStyle: AppTextStyles.label
                            .copyWith(letterSpacing: 1.6),
                      ),
                      child: Text(actionLabel!.toUpperCase()),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
