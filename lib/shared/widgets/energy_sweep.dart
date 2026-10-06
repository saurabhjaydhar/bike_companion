import 'package:flutter/material.dart';

/// A band of light that glides diagonally across its area every [period] —
/// the "charged" sheen on hero cards and primary buttons. Paint-only and
/// ignores touches; the parent should clip it to its shape.
class EnergySweep extends StatefulWidget {
  final Color color;
  final Duration period;

  /// Fraction of [period] the sweep takes to cross; the rest is a pause.
  final double travel;

  const EnergySweep({
    super.key,
    this.color = Colors.white,
    this.period = const Duration(seconds: 5),
    this.travel = 0.3,
  });

  @override
  State<EnergySweep> createState() => _EnergySweepState();
}

class _EnergySweepState extends State<EnergySweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: widget.period);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _ctrl.stop();
    } else if (!_ctrl.isAnimating) {
      _ctrl.repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size.infinite,
            painter: _SweepPainter(_ctrl, widget.color, widget.travel),
          ),
        ),
      );
}

class _SweepPainter extends CustomPainter {
  final Animation<double> anim;
  final Color color;
  final double travel;

  _SweepPainter(this.anim, this.color, this.travel) : super(repaint: anim);

  @override
  void paint(Canvas canvas, Size size) {
    final t = anim.value / travel;
    if (t >= 1) return;
    final eased = Curves.easeInOutCubic.transform(t);
    final band = size.width * 0.35;
    final x = -band + (size.width + band * 2) * eased;
    final rect = Rect.fromLTWH(x - band, 0, band * 2, size.height);
    canvas.save();
    // Lean the band so it reads as a glint rather than a wipe.
    canvas.translate(x, size.height / 2);
    canvas.skew(-0.45, 0);
    canvas.translate(-x, -size.height / 2);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.28),
          color.withValues(alpha: 0),
        ]).createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SweepPainter old) =>
      old.color != color || old.travel != travel;
}
