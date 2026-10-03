import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/active_vehicle_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/hud_panel.dart';
import '../../shared/widgets/shimmer_box.dart';
import '../expenses/expense_style.dart';
import 'garage_provider.dart';
import 'widgets/vehicle_card.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garageAsync = ref.watch(garageProvider);
    final activeVehicleId = ref.watch(activeVehicleIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.garageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: garageAsync.when(
        loading: () => const _GarageSkeleton(),
        error: (e, _) => Center(child: Text(l.commonError('$e'))),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.two_wheeler_rounded,
              heading: l.garageEmptyTitle,
              body: l.garageEmptyBody,
              ctaLabel: l.onboardingAddMyVehicle,
              onCta: () => context.push('/onboarding/add-vehicle'),
            );
          }

          final totalMonthly = items.fold(0.0, (s, i) => s + i.monthTotal);
          final totalAlerts =
              items.fold(0, (s, i) => s + i.healthScore.alerts.length);

          return RefreshIndicator(
            onRefresh: () => ref.read(garageProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _SummaryStrip(
                  vehicleCount: items.length,
                  monthTotal: totalMonthly,
                  alertCount: totalAlerts,
                ),
                if (items.length > 1 &&
                    items.any((i) => i.yearTotal > 0)) ...[
                  const SizedBox(height: AppSpacing.md),
                  _SpendingComparison(items: items),
                ],
                const SizedBox(height: AppSpacing.xl),
                Text(l.garageYourVehicles,
                    style: AppTextStyles.heading3.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary)),
                const SizedBox(height: AppSpacing.md),

                // Vehicle cards with stagger entrance
                ...items.asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _StaggeredItem(
                      index: e.key,
                      child: VehicleCard(
                        item: e.value,
                        isActive: e.value.vehicle.id == activeVehicleId,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setActiveVehicle(ref, e.value.vehicle.id);
                          context.go('/garage/dashboard/${e.value.vehicle.id}');
                        },
                        onDelete: () => ref
                            .read(garageProvider.notifier)
                            .deleteVehicle(e.value.vehicle.id),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: AppSpacing.sm),

                // Add another vehicle
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/onboarding/add-vehicle');
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, size: 18, color: textSecondary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(l.garageAddAnother,
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton loading state
// ---------------------------------------------------------------------------
class _GarageSkeleton extends StatelessWidget {
  const _GarageSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Summary strip skeleton
        const ShimmerBox(height: 72, borderRadius: 12),
        const SizedBox(height: AppSpacing.xl),
        const ShimmerBox(width: 100, height: 20, borderRadius: 6),
        const SizedBox(height: AppSpacing.md),
        // Vehicle card skeletons
        const _VehicleCardSkeleton(),
        const SizedBox(height: AppSpacing.md),
        const _VehicleCardSkeleton(),
      ],
    );
  }
}

class _VehicleCardSkeleton extends StatelessWidget {
  const _VehicleCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const ShimmerBox(width: 48, height: 48, borderRadius: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ShimmerBox(width: 120, height: 16, borderRadius: 4),
                SizedBox(height: 8),
                ShimmerBox(width: 180, height: 12, borderRadius: 4),
                SizedBox(height: 8),
                ShimmerBox(width: 80, height: 12, borderRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const ShimmerBox(width: 48, height: 48, borderRadius: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stagger entrance animation
// ---------------------------------------------------------------------------
class _StaggeredItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredItem({required this.index, required this.child});

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: AppDuration.slow,
      vsync: this,
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 70), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ---------------------------------------------------------------------------
// This year's spending, vehicle by vehicle
// ---------------------------------------------------------------------------
class _SpendingComparison extends StatelessWidget {
  final List<GarageItem> items;
  const _SpendingComparison({required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final track = isDark ? AppColors.borderDark : AppColors.border;
    final l = context.l10n;
    final sorted = [...items]..sort((a, b) => b.yearTotal.compareTo(a.yearTotal));
    final yearTotal = items.fold(0.0, (s, i) => s + i.yearTotal);
    final top = sorted.first.yearTotal;

    return HudPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l.garageSpending,
                    style: AppTextStyles.heading3.copyWith(color: textPrimary)),
              ),
              Text('${l.garageThisYear} · ${rupees(yearTotal)}',
                  style: AppTextStyles.captionMedium
                      .copyWith(color: textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in sorted)
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.small),
              onTap: () => context.go('/expenses/${item.vehicle.id}'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.vehicle.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: textPrimary)),
                        ),
                        Text(rupees(item.yearTotal),
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: textPrimary)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: top > 0 ? item.yearTotal / top : 0,
                        minHeight: 6,
                        color: item.vehicle.colour,
                        backgroundColor: track,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary strip
// ---------------------------------------------------------------------------
class _SummaryStrip extends StatelessWidget {
  final int vehicleCount;
  final double monthTotal;
  final int alertCount;

  const _SummaryStrip({
    required this.vehicleCount,
    required this.monthTotal,
    required this.alertCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final rupeeFormat = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final l = context.l10n;

    return HudPanel(
      glow: AppColors.accent,
      child: Row(
        children: [
          _Stat(
            label: l.garageStatVehicles,
            value: '$vehicleCount',
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _Divider(color: border),
          _Stat(
            label: l.commonThisMonth,
            value: rupeeFormat.format(monthTotal),
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _Divider(color: border),
          _Stat(
            label: l.garageStatAlerts,
            value: '$alertCount',
            valueColor: alertCount > 0
                ? (isDark ? AppColors.warningDark : AppColors.warning)
                : null,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final Color textPrimary;
  final Color textSecondary;

  const _Stat({
    required this.label,
    required this.value,
    this.valueColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(value,
                maxLines: 1,
                style: AppTextStyles.metric.copyWith(
                    fontSize: 22, color: valueColor ?? textPrimary)),
            const SizedBox(height: 2),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label.copyWith(color: textSecondary)),
          ],
        ),
      );
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) => Container(
      width: 1,
      height: 36,
      color: color,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md));
}
