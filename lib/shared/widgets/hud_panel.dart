import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_theme.dart';
import 'energy_sweep.dart';

/// The app's card surface.
///
/// Dark mode: a glassy instrument panel — a top-lit gradient, a hairline
/// border and an optional coloured glow. Light mode: a crisp white panel
/// with a fine border and a tight shadow; a [glow] tints the border.
///
/// [carbon] makes a hero panel: carbon black with orange racing stripes in
/// both themes, and its contents are drawn with the dark theme so text,
/// icons and gauges read light-on-dark automatically.
///
/// Tappable panels squish slightly while pressed. Content is clipped to the
/// rounded shape, so list tiles placed directly inside ripple cleanly to the
/// edges. [sheen] adds a periodic glint of light across the panel.
class HudPanel extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? glow;
  final double radius;
  final bool sheen;
  final bool carbon;
  final VoidCallback? onTap;

  /// Width of the livery stripe band on a [carbon] panel's end edge.
  static const double stripeBand = 46;
  final VoidCallback? onLongPress;

  const HudPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.glow,
    this.radius = AppRadius.large,
    this.sheen = false,
    this.carbon = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<HudPanel> createState() => _HudPanelState();
}

class _HudPanelState extends State<HudPanel> {
  bool _pressed = false;

  void _press(bool down) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    if (_pressed != down) setState(() => _pressed = down);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final carbon = widget.carbon;
    final shape = BorderRadius.circular(widget.radius);
    final glow = widget.glow;

    final Color surface;
    final Color border;
    if (carbon) {
      surface = isDark ? AppColors.surfaceDark : AppColors.carbon;
      border = isDark ? AppColors.borderDark : AppColors.carbonEdge;
    } else {
      surface = isDark ? AppColors.surfaceDark : AppColors.surface;
      border = isDark ? AppColors.borderDark : AppColors.border;
    }
    final edge = glow != null
        ? Color.alphaBlend(glow.withValues(alpha: isDark ? 0.35 : 0.45), border)
        : border;
    final lit = isDark || carbon;

    Widget content = InkWell(
      borderRadius: shape,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onHighlightChanged: _press,
      child: Padding(padding: widget.padding, child: widget.child),
    );
    if (carbon && !isDark) {
      content = Theme(data: AppTheme.dark, child: content);
    }

    return AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: AppDuration.fast,
      curve: Curves.easeOut,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          boxShadow: [
            ...(carbon ? AppShadows.raised(isDark) : AppShadows.panel(isDark)),
            if (glow != null) AppShadows.glow(glow, isDark),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: shape,
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: shape,
              border: Border.all(color: edge, width: lit ? 1 : 1.2),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: lit
                    ? [
                        Color.alphaBlend(
                            Colors.white.withValues(alpha: 0.05), surface),
                        surface,
                      ]
                    : [surface, surface],
              ),
            ),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                if (carbon)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter:
                            _RacingStripesPainter(Directionality.of(context)),
                      ),
                    ),
                  ),
                content,
                if (widget.sheen)
                  Positioned.fill(
                    child: EnergySweep(
                      color: lit ? (glow ?? AppColors.accent) : Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Slanted orange livery stripes in a slim band along the panel's end edge
/// (right in LTR, left in RTL), fading in from the top. Content that sits
/// against the end edge should leave [HudPanel.stripeBand] of room.
class _RacingStripesPainter extends CustomPainter {
  final TextDirection direction;
  const _RacingStripesPainter(this.direction);

  static const _stripe = 7.0;
  static const _gap = 9.0;
  static const _slope = 0.45; // horizontal shift per pixel of height

  @override
  void paint(Canvas canvas, Size size) {
    const band = HudPanel.stripeBand;
    final rtl = direction == TextDirection.rtl;
    final bandRect = rtl
        ? Rect.fromLTWH(0, 0, band, size.height)
        : Rect.fromLTWH(size.width - band, 0, band, size.height);

    canvas.save();
    canvas.clipRect(bandRect);
    canvas.saveLayer(bandRect, Paint());
    final run = size.height * _slope;
    final paint = Paint()..color = AppColors.primary;
    for (var x = bandRect.left - _stripe;
        x < bandRect.right + run;
        x += _stripe + _gap) {
      final top = rtl ? x - run : x;
      final bottom = rtl ? x : x - run;
      canvas.drawPath(
        Path()
          ..moveTo(top, 0)
          ..lineTo(top + _stripe, 0)
          ..lineTo(bottom + _stripe, size.height)
          ..lineTo(bottom, size.height)
          ..close(),
        paint,
      );
    }
    // Fade in from the top so the header row stays clean.
    canvas.drawRect(
      bandRect,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.85),
          ],
          stops: const [0.15, 1],
        ).createShader(bandRect),
    );
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RacingStripesPainter old) => old.direction != direction;
}

/// A [HudPanel] holding a list of rows (usually list tiles) separated by
/// hairline dividers — for grouped lists such as settings or transactions.
class HudGroup extends StatelessWidget {
  final List<Widget> children;

  /// Leading inset for the dividers, so they line up with the row text
  /// rather than the icons.
  final double dividerIndent;

  final Color? glow;

  const HudGroup({
    super.key,
    required this.children,
    this.dividerIndent = 0,
    this.glow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.border;

    return HudPanel(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      glow: glow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, row) in children.indexed) ...[
            if (i > 0) Divider(height: 1, indent: dividerIndent, color: border),
            row,
          ],
        ],
      ),
    );
  }
}
