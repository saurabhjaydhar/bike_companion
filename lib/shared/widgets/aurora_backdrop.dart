import 'dart:math';
import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import '../../core/theme/app_colors.dart';

/// Page background: soft colour blobs drifting slowly over a faint dot grid.
///
/// Every backdrop paints in screen coordinates against one shared clock, so
/// two backdrops on screen at once (a page and the nav shell around it) line
/// up seamlessly, and the aurora stays put while page content slides over it.
///
/// Scaffolds and app bars inside are made transparent so the aurora shows
/// through. Motion stops when the system asks for reduced animations.
class AuroraBackdrop extends StatefulWidget {
  final Widget child;
  const AuroraBackdrop({super.key, required this.child});

  @override
  State<AuroraBackdrop> createState() => _AuroraBackdropState();
}

/// Shared clock so every backdrop shows the same phase.
final Stopwatch _clock = Stopwatch()..start();

class _AuroraBackdropState extends State<AuroraBackdrop>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _time = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(
        (_) => _time.value = _clock.elapsedMilliseconds / 1000);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final still = MediaQuery.disableAnimationsOf(context);
    if (still && _ticker.isActive) _ticker.stop();
    if (!still && !_ticker.isActive) _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: _Aurora(
              time: _time,
              isDark: isDark,
              screen: MediaQuery.sizeOf(context),
            ),
          ),
        ),
        Theme(
          data: theme.copyWith(
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme:
                theme.appBarTheme.copyWith(backgroundColor: Colors.transparent),
          ),
          child: widget.child,
        ),
      ],
    );
  }
}

class _Aurora extends LeafRenderObjectWidget {
  final ValueNotifier<double> time;
  final bool isDark;
  final Size screen;

  const _Aurora({
    required this.time,
    required this.isDark,
    required this.screen,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderAurora(time, isDark, screen);

  @override
  void updateRenderObject(BuildContext context, _RenderAurora render) {
    render
      ..time = time
      ..isDark = isDark
      ..screen = screen;
  }
}

class _RenderAurora extends RenderBox {
  _RenderAurora(this._time, this._isDark, this._screen);

  ValueNotifier<double> _time;
  set time(ValueNotifier<double> v) {
    if (v == _time) return;
    if (attached) {
      _time.removeListener(markNeedsPaint);
      v.addListener(markNeedsPaint);
    }
    _time = v;
  }

  bool _isDark;
  set isDark(bool v) {
    if (v == _isDark) return;
    _isDark = v;
    markNeedsPaint();
  }

  Size _screen;
  set screen(Size v) {
    if (v == _screen) return;
    _screen = v;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _time.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _time.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  /// Blob colour, light-mode alpha, dark-mode alpha, size (× screen width),
  /// anchor (fractions of the screen) and drift period in seconds.
  static const _blobs = [
    (AppColors.primary, 0.30, 0.13, 0.95, Offset(0.95, 0.05), 31.0),
    (AppColors.accent, 0.40, 0.10, 0.85, Offset(0.0, 0.35), 37.0),
    (AppColors.statCost, 0.26, 0.12, 0.90, Offset(0.85, 0.75), 43.0),
    (Color(0xFFFF4D8D), 0.16, 0.06, 0.70, Offset(0.1, 0.95), 53.0),
  ];

  static Size? _dotsSize;
  static List<Offset> _dots = const [];

  /// Grid points covering the screen, cached per screen size.
  static List<Offset> _dotsFor(Size screen) {
    if (screen == _dotsSize) return _dots;
    const step = 22.0;
    _dotsSize = screen;
    return _dots = [
      for (var y = step / 2; y < screen.height; y += step)
        for (var x = step / 2; x < screen.width; x += step) Offset(x, y),
    ];
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final rect = offset & size;
    final base = _isDark ? AppColors.backgroundDark : AppColors.background;
    canvas.drawRect(rect, Paint()..color = base);

    canvas.save();
    canvas.clipRect(rect);
    // Paint in screen coordinates so neighbouring backdrops line up.
    final global = localToGlobal(Offset.zero);
    canvas.translate(offset.dx - global.dx, offset.dy - global.dy);

    final t = _time.value;
    final w = _screen.width;
    final h = _screen.height;
    for (final (colour, lightA, darkA, scale, anchor, period) in _blobs) {
      final phase = 2 * pi * t / period;
      final centre = Offset(
        (anchor.dx + 0.12 * sin(phase)) * w,
        (anchor.dy + 0.08 * cos(phase * 0.8)) * h,
      );
      final radius = w * scale * (1 + 0.08 * sin(phase * 1.3));
      final a = _isDark ? darkA : lightA;
      canvas.drawCircle(
        centre,
        radius,
        Paint()
          ..shader = RadialGradient(colors: [
            colour.withValues(alpha: a),
            colour.withValues(alpha: a * 0.4),
            colour.withValues(alpha: 0),
          ], stops: const [0, 0.45, 1])
              .createShader(Rect.fromCircle(center: centre, radius: radius)),
      );
    }

    // Faint dot grid — the "instrument panel" texture.
    canvas.drawPoints(
      PointMode.points,
      _dotsFor(_screen),
      Paint()
        ..color = (_isDark ? Colors.white : AppColors.shadow)
            .withValues(alpha: _isDark ? 0.05 : 0.07)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }
}
