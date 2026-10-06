import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Entrance animation: the child fades in, rises and settles from slightly
/// smaller, starting [index] × 60 ms after mount so a column of sections
/// cascades in. Shows immediately when the system asks for reduced motion.
class Reveal extends StatefulWidget {
  final int index;
  final Widget child;

  const Reveal({super.key, this.index = 0, required this.child});

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    duration: const Duration(milliseconds: 520),
    vsync: this,
  );
  late final Animation<double> _curve =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _ctrl.value = 1;
      return;
    }
    Future.delayed(AppDuration.stagger * (widget.index * 1.2), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _curve,
        child: widget.child,
        builder: (context, child) {
          final t = _curve.value;
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, 24 * (1 - t)),
              child: Transform.scale(scale: 0.97 + 0.03 * t, child: child),
            ),
          );
        },
      );
}
