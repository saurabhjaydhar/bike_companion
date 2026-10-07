import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import 'clay_icon.dart';
import 'hud_panel.dart';

/// First-time guidance: a short spotlight tour on Home and one dismissible
/// tip card per screen. Each is shown once; Settings can bring them back.
class Tips {
  static const _prefix = 'tip_seen_';

  static const homeTour = 'home_tour';
  static const expenses = 'expenses';
  static const service = 'service';
  static const documents = 'documents';
  static const fuelLog = 'fuel_log';
  static const garage = 'garage';

  static Future<bool> isSeen(String id) async =>
      (await SharedPreferences.getInstance()).getBool('$_prefix$id') ?? false;

  static Future<void> markSeen(String id) async =>
      (await SharedPreferences.getInstance()).setBool('$_prefix$id', true);

  /// Shows every tip and the tour again.
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().where((k) => k.startsWith(_prefix))) {
      await prefs.remove(key);
    }
  }
}

/// A one-line hint at the top of a screen, shown until dismissed.
class TipCard extends StatefulWidget {
  final String id;
  final String text;
  final EdgeInsetsGeometry padding;

  const TipCard({
    super.key,
    required this.id,
    required this.text,
    this.padding = const EdgeInsets.only(bottom: AppSpacing.md),
  });

  @override
  State<TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<TipCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Tips.isSeen(widget.id).then((seen) {
      if (mounted && !seen) setState(() => _visible = true);
    });
  }

  void _dismiss() {
    HapticFeedback.selectionClick();
    setState(() => _visible = false);
    Tips.markSeen(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return AnimatedSize(
      duration: AppDuration.normal,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !_visible
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: widget.padding,
              child: HudPanel(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md,
                    AppSpacing.md, AppSpacing.xs, AppSpacing.md),
                child: Row(
                  children: [
                    const ClayIcon(
                        icon: Icons.lightbulb_rounded,
                        color: AppColors.warning,
                        size: 34),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(widget.text,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: textPrimary, height: 1.4)),
                    ),
                    IconButton(
                      tooltip: context.l10n.tipGotIt,
                      icon: Icon(Icons.close_rounded, color: textSecondary),
                      onPressed: _dismiss,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// One stop of a [showSpotlightTour].
class TourStep {
  final GlobalKey target;
  final String title;
  final String body;
  const TourStep({required this.target, required this.title, required this.body});
}

/// Dims the screen and walks through [steps], cutting a hole around each
/// target with a short explanation next to it. Skippable at every step.
/// Steps whose target isn't on screen are left out.
Future<void> showSpotlightTour(BuildContext context, List<TourStep> steps) {
  final visible = steps.where((s) => _rectOf(s.target) != null).toList();
  if (visible.isEmpty) return Future.value();
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: AppDuration.normal,
    pageBuilder: (context, a1, a2) => _Tour(steps: visible),
    transitionBuilder: (context, anim, a2, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

Rect? _rectOf(GlobalKey key) {
  final box = key.currentContext?.findRenderObject() as RenderBox?;
  if (box == null || !box.attached || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}

class _Tour extends StatefulWidget {
  final List<TourStep> steps;
  const _Tour({required this.steps});

  @override
  State<_Tour> createState() => _TourState();
}

class _TourState extends State<_Tour> {
  int _i = 0;

  void _next() {
    HapticFeedback.selectionClick();
    if (_i == widget.steps.length - 1) {
      Navigator.pop(context);
    } else {
      setState(() => _i++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final step = widget.steps[_i];
    final screen = MediaQuery.of(context).size;
    final hole = (_rectOf(step.target) ?? Rect.zero).inflate(6);
    final last = _i == widget.steps.length - 1;
    // Put the explanation on whichever side of the target has more room.
    final below = hole.center.dy < screen.height / 2;
    const cardWidth = 300.0;
    final left = (hole.center.dx - cardWidth / 2)
        .clamp(AppSpacing.lg, screen.width - cardWidth - AppSpacing.lg);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Tapping the dimmed area also moves on.
          Positioned.fill(
            child: GestureDetector(
              onTap: _next,
              child: TweenAnimationBuilder<Rect?>(
                tween: RectTween(end: hole),
                duration: AppDuration.normal,
                curve: Curves.easeOutCubic,
                builder: (context, r, _) => CustomPaint(
                  painter: _SpotlightPainter(r ?? hole),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: AppDuration.normal,
            curve: Curves.easeOutCubic,
            left: left,
            width: cardWidth,
            top: below ? hole.bottom + AppSpacing.md : null,
            bottom: below ? null : screen.height - hole.top + AppSpacing.md,
            child: _TourCard(
              title: step.title,
              body: step.body,
              counter: '${_i + 1}/${widget.steps.length}',
              nextLabel: last ? l.tipGotIt : l.tipNext,
              skipLabel: last ? null : l.tipSkip,
              onNext: _next,
              onSkip: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect hole;
  _SpotlightPainter(this.hole);

  @override
  void paint(Canvas canvas, Size size) {
    final rrect =
        RRect.fromRectAndRadius(hole, const Radius.circular(AppRadius.large));
    // Even-odd fill leaves the inner shape uncovered.
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(Offset.zero & size)
        ..addRRect(rrect),
      Paint()..color = Colors.black.withValues(alpha: 0.72),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.hole != hole;
}

class _TourCard extends StatelessWidget {
  final String title;
  final String body;
  final String counter;
  final String nextLabel;
  final String? skipLabel;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TourCard({
    required this.title,
    required this.body,
    required this.counter,
    required this.nextLabel,
    required this.skipLabel,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return HudPanel(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.sm, AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title.toUpperCase(),
                    style: AppTextStyles.heading3.copyWith(color: textPrimary)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Text(counter,
                    style: AppTextStyles.data
                        .copyWith(fontSize: 12, color: textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Text(body,
                style: AppTextStyles.body.copyWith(color: textSecondary)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (skipLabel != null)
                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(foregroundColor: textSecondary),
                  child: Text(skipLabel!),
                ),
              TextButton(onPressed: onNext, child: Text(nextLabel)),
            ],
          ),
        ],
      ),
    );
  }
}
