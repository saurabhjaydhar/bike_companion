import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// A forward-leaning parallelogram — the slanted "livery" shape used for
/// chips and the primary button. [slant] is how far the top edge is shifted
/// right of the bottom edge.
class ParallelogramBorder extends OutlinedBorder {
  final double slant;

  const ParallelogramBorder({this.slant = 12, super.side});

  Path _path(Rect rect) {
    final s = slant.clamp(0.0, rect.width / 3);
    return Path()
      ..moveTo(rect.left + s, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right - s, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _path(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _path(rect.deflate(side.strokeInset));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0) return;
    canvas.drawPath(
        _path(rect.deflate(side.strokeInset / 2)), side.toPaint());
  }

  @override
  ParallelogramBorder copyWith({BorderSide? side, double? slant}) =>
      ParallelogramBorder(slant: slant ?? this.slant, side: side ?? this.side);

  @override
  ShapeBorder scale(double t) =>
      ParallelogramBorder(slant: slant * t, side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => a is ParallelogramBorder
      ? ParallelogramBorder(
          slant: lerpDouble(a.slant, slant, t)!,
          side: BorderSide.lerp(a.side, side, t))
      : super.lerpFrom(a, t);

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) => b is ParallelogramBorder
      ? ParallelogramBorder(
          slant: lerpDouble(slant, b.slant, t)!,
          side: BorderSide.lerp(side, b.side, t))
      : super.lerpTo(b, t);

  @override
  bool operator ==(Object other) =>
      other is ParallelogramBorder &&
      other.slant == slant &&
      other.side == side;

  @override
  int get hashCode => Object.hash(slant, side);
}
