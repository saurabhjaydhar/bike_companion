import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import 'energy_sweep.dart';

/// The app's card surface.
///
/// Dark mode: a glassy instrument panel — a top-lit gradient, a hairline
/// border and an optional coloured glow. Light mode: soft clay — lit from the
/// top left with a white highlight, a deep soft shadow to the bottom right
/// and a bright rim along the top edge; a [glow] also washes the top-left
/// corner with its colour.
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
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const HudPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.glow,
    this.radius = AppRadius.large,
    this.sheen = false,
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
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final shape = BorderRadius.circular(widget.radius);
    final glow = widget.glow;

    final List<Color> fill;
    if (isDark) {
      fill = [
        Color.alphaBlend(Colors.white.withValues(alpha: 0.04), surface),
        surface,
      ];
    } else if (glow != null) {
      fill = [
        Color.alphaBlend(glow.withValues(alpha: 0.10), surface),
        surface,
        const Color(0xFFF3F6FB),
      ];
    } else {
      fill = [surface, surface, const Color(0xFFF3F6FB)];
    }

    return AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: AppDuration.fast,
      curve: Curves.easeOut,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          boxShadow: [
            ...AppShadows.clay(isDark),
            if (glow != null) AppShadows.glow(glow, isDark),
          ],
        ),
        child: CustomPaint(
          foregroundPainter: _RimPainter(
            radius: widget.radius,
            isDark: isDark,
            edge: glow != null
                ? Color.alphaBlend(
                    glow.withValues(alpha: isDark ? 0.35 : 0.30), border)
                : border,
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: shape,
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: isDark ? Alignment.topCenter : Alignment.topLeft,
                  end:
                      isDark ? Alignment.bottomCenter : Alignment.bottomRight,
                  colors: fill,
                ),
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  InkWell(
                    borderRadius: shape,
                    onTap: widget.onTap,
                    onLongPress: widget.onLongPress,
                    onHighlightChanged: _press,
                    child: Padding(padding: widget.padding, child: widget.child),
                  ),
                  if (widget.sheen)
                    Positioned.fill(
                      child: EnergySweep(
                        color: isDark
                            ? (glow ?? AppColors.accent)
                            : Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Edge of a panel: in light mode a bright rim along the top-left fading to
/// a faint edge at the bottom right, like light catching a rounded surface;
/// in dark mode a hairline with a slightly brighter top.
class _RimPainter extends CustomPainter {
  final double radius;
  final bool isDark;
  final Color edge;

  _RimPainter({required this.radius, required this.isDark, required this.edge});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(0.5);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final colors = isDark
        ? [Color.alphaBlend(Colors.white.withValues(alpha: 0.08), edge), edge]
        : [
            Colors.white,
            Colors.white.withValues(alpha: 0.6),
            edge.withValues(alpha: 0.7),
          ];
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isDark ? 1 : 1.2
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_RimPainter old) =>
      old.radius != radius || old.isDark != isDark || old.edge != edge;
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
