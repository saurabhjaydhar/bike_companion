import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';

/// The bottom navigation: a floating carbon bar with text-only uppercase
/// tabs, the active one in ignition orange — like a dash's mode selector.
/// Carbon in both themes (with a hairline and glow in dark mode).
class LiveryNavBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const LiveryNavBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shape = BorderRadius.circular(AppRadius.large - 4);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.carbon,
        borderRadius: shape,
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.carbonEdge),
        boxShadow: isDark
            ? [AppShadows.glow(AppColors.primary, true)]
            : AppShadows.raised(false),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              for (final (i, label) in labels.indexed)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == selectedIndex,
                    child: InkWell(
                      onTap: () => onSelected(i),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: AppDuration.fast,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 13,
                            letterSpacing: 1.8,
                            color: i == selectedIndex
                                ? AppColors.primary
                                : const Color(0xFF7D8088),
                          ),
                          child: Text(
                            label.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
