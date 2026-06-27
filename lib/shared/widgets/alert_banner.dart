import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum AlertType { info, success, warning, danger }

/// Slide-in banner for warnings, errors, success, and info messages.
class AlertBanner extends StatefulWidget {
  final String message;
  final AlertType type;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;

  const AlertBanner({
    super.key,
    required this.message,
    this.type = AlertType.warning,
    this.onDismiss,
    this.onTap,
  });

  @override
  State<AlertBanner> createState() => _AlertBannerState();
}

class _AlertBannerState extends State<AlertBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: AppDuration.slow);
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  _BannerStyle _style(bool isDark) {
    switch (widget.type) {
      case AlertType.success:
        return _BannerStyle(
          bg: isDark
              ? AppColors.successDark.withValues(alpha: 0.15)
              : AppColors.success.withValues(alpha: 0.1),
          border: isDark ? AppColors.successDark : AppColors.success,
          icon: Icons.check_circle_outline_rounded,
          iconColor: isDark ? AppColors.successDark : AppColors.success,
        );
      case AlertType.danger:
        return _BannerStyle(
          bg: isDark
              ? AppColors.dangerDark.withValues(alpha: 0.15)
              : AppColors.danger.withValues(alpha: 0.1),
          border: isDark ? AppColors.dangerDark : AppColors.danger,
          icon: Icons.error_outline_rounded,
          iconColor: isDark ? AppColors.dangerDark : AppColors.danger,
        );
      case AlertType.info:
        return _BannerStyle(
          bg: AppColors.primary.withValues(alpha: 0.1),
          border: AppColors.primary,
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.primary,
        );
      case AlertType.warning:
        return _BannerStyle(
          bg: isDark
              ? AppColors.warningDark.withValues(alpha: 0.15)
              : AppColors.warning.withValues(alpha: 0.1),
          border: isDark ? AppColors.warningDark : AppColors.warning,
          icon: Icons.warning_amber_rounded,
          iconColor: isDark ? AppColors.warningDark : AppColors.warning,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = _style(isDark);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return SlideTransition(
      position: _slide,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: style.bg,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: style.border.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(style.icon, size: 18, color: style.iconColor),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  widget.message,
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: textPrimary),
                ),
              ),
              if (widget.onDismiss != null) ...[
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: widget.onDismiss,
                  child: Icon(Icons.close_rounded,
                      size: 16, color: style.iconColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerStyle {
  final Color bg;
  final Color border;
  final IconData icon;
  final Color iconColor;

  const _BannerStyle({
    required this.bg,
    required this.border,
    required this.icon,
    required this.iconColor,
  });
}
