import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/active_vehicle_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/vehicle.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/vehicle_avatar.dart';

/// Opened from the vehicle name on the dashboard: jump to another vehicle,
/// add one, or open the full garage.
Future<void> showVehicleSwitcher(
  BuildContext context,
  WidgetRef ref, {
  required List<Vehicle> vehicles,
  required String activeVehicleId,
}) =>
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheet) {
        final l = sheet.l10n;
        final isDark = Theme.of(sheet).brightness == Brightness.dark;
        final textPrimary =
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
        final textSecondary =
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

        void go(String location, {bool push = false}) {
          Navigator.pop(sheet);
          push ? context.push(location) : context.go(location);
        }

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheet).size.height * 0.7),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.sm),
                  child: Text(l.garageYourVehicles.toUpperCase(),
                      style:
                          AppTextStyles.heading2.copyWith(color: textPrimary)),
                ),
                for (final v in vehicles)
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    leading: VehicleAvatar(
                        colour: v.colour, type: v.type, size: 42),
                    title: Text(v.name.toUpperCase(),
                        style: AppTextStyles.heading3
                            .copyWith(color: textPrimary)),
                    subtitle: v.regNumber.isEmpty
                        ? null
                        : Text(v.regNumber,
                            style: AppTextStyles.caption
                                .copyWith(color: textSecondary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (v.id == activeVehicleId)
                          const Icon(Icons.check_rounded,
                              color: AppColors.primary),
                        IconButton(
                          tooltip: l.vehicleEditTitle,
                          icon: Icon(Icons.edit_outlined,
                              color: textSecondary),
                          onPressed: () {
                            Navigator.pop(sheet);
                            context.push('/vehicle/edit', extra: v);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      if (v.id == activeVehicleId) {
                        Navigator.pop(sheet);
                        return;
                      }
                      setActiveVehicle(ref, v.id);
                      go('/garage/dashboard/${v.id}');
                    },
                  ),
                const Divider(height: AppSpacing.lg),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  leading: const Icon(Icons.add_rounded,
                      color: AppColors.primary),
                  title: Text(l.garageAddAnother,
                      style: AppTextStyles.bodySemiBold
                          .copyWith(color: textPrimary)),
                  onTap: () => go('/onboarding/add-vehicle', push: true),
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  leading: Icon(Icons.garage_outlined, color: textSecondary),
                  title: Text(l.garageTitle,
                      style: AppTextStyles.bodySemiBold
                          .copyWith(color: textPrimary)),
                  onTap: () => go('/garage'),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        );
      },
    );
