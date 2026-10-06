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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  /// The shockwave that pulses out once the gauge has charged up.
  late final AnimationController _shock = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

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
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.score > 0) {
        _shock.forward(from: 0);
      }
    });
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
    _shock.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark ? AppColors.trackDark : AppColors.track;
    final face = isDark
        ? const [AppColors.surfaceVariantDark, AppColors.surfaceDark]
        : const [AppColors.surface, AppColors.surfaceVariant];
    final ringColor = HealthRing.gradeColor(widget.grade, isDark: isDark);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return AnimatedBuilder(
      animation: Listenable.merge([_animation, _shock]),
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _GaugePainter(
              progress: _animation.value * widget.score / 100,
              trackColor: trackColor,
              ringColor: ringColor,
              faceColors: face,
              strokeWidth: widget.size * 0.07,
              charging: _controller.isAnimating,
              shock: _shock.isAnimating ? _shock.value : null,
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

  /// Centre and edge colours of the dial face inside the arc.
  final List<Color> faceColors;
  final double strokeWidth;

  /// While the gauge fills, sparks crackle off the tip.
  final bool charging;

  /// Progress of the shockwave after filling, or null when there is none.
  final double? shock;

  static const _start = 0.75 * pi; // bottom-left
  static const _sweep = 1.5 * pi; // 270°
  static const _ticks = 40;

  _GaugePainter({
    required this.progress,
    required this.trackColor,
    required this.ringColor,
    required this.faceColors,
    required this.strokeWidth,
    this.charging = false,
    this.shock,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.width / 2;
    final arcRadius = outer - strokeWidth * 2.2;
    final rect = Rect.fromCircle(center: center, radius: arcRadius);
    final p = progress.clamp(0.0, 1.0);

    // Dial face: a softly shaded disc behind the readout.
    final faceRadius = arcRadius - strokeWidth * 1.1;
    canvas.drawCircle(
      center + Offset(0, strokeWidth * 0.25),
      faceRadius,
      Paint()
        ..color = ringColor.withValues(alpha: 0.18)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.8),
    );
    canvas.drawCircle(
      center,
      faceRadius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          colors: faceColors,
        ).createShader(Rect.fromCircle(center: center, radius: faceRadius)),
    );

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

    if (charging) _paintSparks(canvas, tip, tipAngle);

    // Shockwave: a ring expanding from the arc and fading out.
    if (shock case final s?) {
      final eased = Curves.easeOutCubic.transform(s);
      canvas.drawCircle(
        center,
        arcRadius + (outer * 1.05 - arcRadius) * eased,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * (1 - eased) * 0.8 + 0.5
          ..color = ringColor.withValues(alpha: 0.55 * (1 - s))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.3),
      );
      // A brief flare at the tip as the charge lands.
      canvas.drawCircle(
        tip,
        strokeWidth * (0.9 + 1.4 * eased),
        Paint()
          ..color = ringColor.withValues(alpha: 0.5 * (1 - s))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth),
      );
    }
  }

  /// Small jagged bolts arcing off the tip, re-drawn at random every frame
  /// so they flicker like electricity.
  void _paintSparks(Canvas canvas, Offset tip, double tipAngle) {
    final rnd = Random((progress * 10000).toInt());
    final glow = Paint()
      ..color = ringColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.35
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.3);
    // A solid bolt in the ring colour with a white-hot core, so the sparks
    // read on white cards as well as black.
    final bolt = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final core = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var b = 0; b < 3; b++) {
      // Fan out around the outward direction and slightly backwards along
      // the arc, like a trail behind the moving tip.
      final dir = tipAngle + (rnd.nextDouble() - 0.5) * 2.4 - 0.4;
      final length = strokeWidth * (1.6 + rnd.nextDouble() * 1.8);
      final path = Path()..moveTo(tip.dx, tip.dy);
      const segments = 4;
      for (var i = 1; i <= segments; i++) {
        final along = length * i / segments;
        final jitter = (rnd.nextDouble() - 0.5) * strokeWidth * 0.9;
        final p = tip +
            Offset(cos(dir), sin(dir)) * along +
            Offset(-sin(dir), cos(dir)) * jitter;
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, glow);
      canvas.drawPath(path, bolt);
      canvas.drawPath(path, core);
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress ||
      old.ringColor != ringColor ||
      old.trackColor != trackColor ||
      old.charging != charging ||
      old.shock != shock;
}
