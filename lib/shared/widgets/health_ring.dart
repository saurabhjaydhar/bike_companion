import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/health_score.dart';

/// Animated speedometer-style health gauge: a 270° arc with tick marks that
/// light up to the score, a glowing tip, and a digital readout in the middle.
class HealthRing extends StatefulWidget {
  final int score;
  final HealthGrade grade;
  final double size;

  const HealthRing({
    super.key,
    required this.score,
    required this.grade,
    this.size = 80,
  });

  /// Colour for a grade — shared with other widgets that show health.
  static Color gradeColor(HealthGrade grade, {required bool isDark}) {
    switch (grade) {
      case HealthGrade.excellent:
      case HealthGrade.good:
        return isDark ? AppColors.successDark : AppColors.success;
      case HealthGrade.fair:
        return isDark ? AppColors.warningDark : AppColors.warning;
      case HealthGrade.poor:
      case HealthGrade.critical:
        return isDark ? AppColors.dangerDark : AppColors.danger;
    }
  }

  @override
  State<HealthRing> createState() => _HealthRingState();
}

class _HealthRingState extends State<HealthRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDuration.healthRing,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(HealthRing old) {
    super.didUpdateWidget(old);
    if (old.score != widget.score) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark ? AppColors.borderDark : AppColors.border;
    final ringColor = HealthRing.gradeColor(widget.grade, isDark: isDark);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _GaugePainter(
              progress: _animation.value * widget.score / 100,
              trackColor: trackColor,
              ringColor: ringColor,
              strokeWidth: widget.size * 0.07,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(widget.score * _animation.value).round()}',
                    style: AppTextStyles.metric.copyWith(
                      color: textPrimary,
                      fontSize: widget.size * 0.27,
                      shadows: [
                        Shadow(
                            color: ringColor.withValues(alpha: 0.6),
                            blurRadius: widget.size * 0.12),
                      ],
                    ),
                  ),
                  Text(
                    '%',
                    style: AppTextStyles.label.copyWith(
                      color: textSecondary,
                      fontSize: max(9, widget.size * 0.09),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color ringColor;
  final double strokeWidth;

  static const _start = 0.75 * pi; // bottom-left
  static const _sweep = 1.5 * pi; // 270°
  static const _ticks = 40;

  _GaugePainter({
    required this.progress,
    required this.trackColor,
    required this.ringColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.width / 2;
    final arcRadius = outer - strokeWidth * 2.2;
    final rect = Rect.fromCircle(center: center, radius: arcRadius);
    final p = progress.clamp(0.0, 1.0);

    // Tick marks around the outside; lit up to the current value.
    for (var i = 0; i <= _ticks; i++) {
      final t = i / _ticks;
      final angle = _start + _sweep * t;
      final major = i % 5 == 0;
      final len = strokeWidth * (major ? 1.3 : 0.7);
      final r1 = outer - strokeWidth * 0.3;
      final dir = Offset(cos(angle), sin(angle));
      final lit = t <= p && p > 0;
      canvas.drawLine(
        center + dir * r1,
        center + dir * (r1 - len),
        Paint()
          ..color = lit
              ? ringColor.withValues(alpha: major ? 1 : 0.7)
              : trackColor.withValues(alpha: major ? 1 : 0.6)
          ..strokeWidth = major ? strokeWidth * 0.28 : strokeWidth * 0.18
          ..strokeCap = StrokeCap.round,
      );
    }

    // Track
    canvas.drawArc(
      rect,
      _start,
      _sweep,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    if (p <= 0) return;

    final sweep = _sweep * p;
    final gradient = SweepGradient(
      startAngle: _start,
      endAngle: _start + _sweep,
      tileMode: TileMode.clamp,
      colors: [ringColor.withValues(alpha: 0.35), ringColor],
      transform: const GradientRotation(0),
    ).createShader(rect);

    // Glow under the arc
    canvas.drawArc(
      rect,
      _start,
      sweep,
      false,
      Paint()
        ..color = ringColor.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 1.6
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.9),
    );

    // Progress arc
    canvas.drawArc(
      rect,
      _start,
      sweep,
      false,
      Paint()
        ..shader = gradient
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Glowing tip
    final tipAngle = _start + sweep;
    final tip = center + Offset(cos(tipAngle), sin(tipAngle)) * arcRadius;
    canvas.drawCircle(
      tip,
      strokeWidth * 0.9,
      Paint()
        ..color = ringColor.withValues(alpha: 0.6)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.8),
    );
    canvas.drawCircle(tip, strokeWidth * 0.32, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress ||
      old.ringColor != ringColor ||
      old.trackColor != trackColor;
}
