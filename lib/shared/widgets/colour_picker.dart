import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// Row of bike colour swatches; [selected] and [onChanged] use '#RRGGBB'.
class ColourPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const ColourPicker({super.key, required this.selected, required this.onChanged});

  static const _colours = [
    ('#1A56DB', Color(0xFF1A56DB)),
    ('#EF4444', Color(0xFFEF4444)),
    ('#0E9F6E', Color(0xFF0E9F6E)),
    ('#F59E0B', Color(0xFFF59E0B)),
    ('#8B5CF6', Color(0xFF8B5CF6)),
    ('#EC4899', Color(0xFFEC4899)),
    ('#06B6D4', Color(0xFF06B6D4)),
    ('#111827', Color(0xFF111827)),
  ];

  /// The swatch closest to a colour name as printed on an RC ("LTNG BLACK",
  /// "ROYAL BLUE"), or null when none is close (e.g. white, silver).
  static String? hexForName(String? name) {
    if (name == null) return null;
    final upper = name.toUpperCase();
    const words = {
      'BLACK': '#111827',
      'RED': '#EF4444',
      'MAROON': '#EF4444',
      'BLUE': '#1A56DB',
      'NAVY': '#1A56DB',
      'GREEN': '#0E9F6E',
      'YELLOW': '#F59E0B',
      'ORANGE': '#F59E0B',
      'GOLD': '#F59E0B',
      'PURPLE': '#8B5CF6',
      'VIOLET': '#8B5CF6',
      'PINK': '#EC4899',
      'CYAN': '#06B6D4',
      'TEAL': '#06B6D4',
      'TURQUOISE': '#06B6D4',
    };
    for (final MapEntry(:key, :value) in words.entries) {
      if (RegExp('\\b$key\\b').hasMatch(upper)) return value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: _colours.map(((String, Color) entry) {
        final (hex, colour) = entry;
        final isSelected = selected == hex;
        return GestureDetector(
          onTap: () => onChanged(hex),
          child: AnimatedContainer(
            duration: AppDuration.fast,
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colour,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.white24,
                width: isSelected ? 2.5 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: colour.withValues(alpha: 0.6), blurRadius: 10)]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
