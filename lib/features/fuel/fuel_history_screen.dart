import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/hud_panel.dart';
import '../../shared/widgets/stat_card.dart';
import 'fuel_provider.dart';
import '../../shared/widgets/clay_icon.dart';

class FuelHistoryScreen extends ConsumerWidget {
  final String vehicleId;
  const FuelHistoryScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(fuelHistoryProvider(vehicleId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final rupee =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.fuelHistoryTitle)),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (logs) {
          if (logs.isEmpty) {
            return EmptyState(
              icon: Icons.local_gas_station_rounded,
              heading: l10n.fuelHistoryEmptyTitle,
              body: l10n.fuelHistoryEmptyBody,
            );
          }

          final withMileage = logs.where((l) => l.mileageCalculated != null);
          final avgMileage = withMileage.isEmpty
              ? null
              : withMileage.map((l) => l.mileageCalculated!).reduce((a, b) => a + b) /
                  withMileage.length;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              if (avgMileage != null)
                StatCard(
                  label: l10n.fuelAvgMileageAllTime,
                  value: '${avgMileage.toStringAsFixed(1)} km/L',
                ),
              const SizedBox(height: AppSpacing.xl),
              ...logs.map((log) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: HudPanel(
                  child: Row(
                    children: [
                      ClayIcon(icon: Icons.local_gas_station_rounded, color: AppColors.primary, size: 38),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('d MMM y', l10n.localeName).format(log.date),
                              style: AppTextStyles.bodySemiBold.copyWith(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${NumberFormat('#,##,###').format(log.odometer)} km',
                              style: AppTextStyles.caption
                                  .copyWith(color: textSecondary),
                            ),
                            if (log.fuelStation != null)
                              Text(
                                log.fuelStation!,
                                style: AppTextStyles.caption
                                    .copyWith(color: textSecondary),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (log.mileageCalculated != null)
                            Text(
                              '${log.mileageCalculated!.toStringAsFixed(1)} km/L',
                              style: AppTextStyles.bodySemiBold
                                  .copyWith(color: AppColors.primary),
                            ),
                          if (log.amount != null)
                            Text(
                              rupee.format(log.amount),
                              style: AppTextStyles.caption
                                  .copyWith(color: textSecondary),
                            ),
                          if (log.litres != null)
                            Text(
                              '${log.litres!.toStringAsFixed(1)} L',
                              style: AppTextStyles.caption
                                  .copyWith(color: textSecondary),
                            ),
                        ],
                      ),
                    ],
                  ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
