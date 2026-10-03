import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/vehicle.dart';
import '../../l10n/l10n.dart';

/// Three large cards — Bike, Scooter, Car — to say what kind of vehicle
/// this is.
class VehicleTypePicker extends StatelessWidget {
  final VehicleType selected;
  final ValueChanged<VehicleType> onChanged;

  const VehicleTypePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      children: [
        for (final (i, type) in VehicleType.values.indexed) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _TypeCard(
              type: type,
              label: l.vehicleTypeLabel(type),
              selected: type == selected,
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(type);
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final VehicleType type;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    const colour = AppColors.primary;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: AnimatedContainer(
          duration: AppDuration.fast,
          height: 92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(
              color: selected ? colour : border,
              width: selected ? 1.6 : 1,
            ),
            gradient: selected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colour.withValues(alpha: 0.22),
                      colour.withValues(alpha: 0.04),
                    ],
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colour.withValues(alpha: 0.3),
                      blurRadius: 18,
                      spreadRadius: -6,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type.icon,
                  size: 34, color: selected ? colour : textSecondary),
              const SizedBox(height: AppSpacing.xs),
              Text(label,
                  style: AppTextStyles.captionMedium.copyWith(
                    color: selected ? colour : textSecondary,
                    fontWeight: selected ? FontWeight.w700 : null,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
