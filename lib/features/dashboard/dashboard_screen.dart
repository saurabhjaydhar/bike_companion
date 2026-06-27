import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/active_bike_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/health_score.dart';
import '../../shared/widgets/alert_banner.dart';
import '../../shared/widgets/health_ring.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/shimmer_box.dart';
import '../../shared/widgets/stat_card.dart';
import 'dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final String bikeId;
  const DashboardScreen({super.key, required this.bikeId});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    // Set this bike as active when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setActiveBike(ref, widget.bikeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashAsync = ref.watch(dashboardProvider(widget.bikeId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/garage')),
        title: dashAsync.maybeWhen(
          data: (d) => Text(d.bike.name),
          orElse: () => const Text('Dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: dashAsync.when(
        loading: () => const _DashboardSkeleton(),
        error: (e, _) => Center(child: Text('$e')),
        data: (dash) => RefreshIndicator(
          onRefresh: () => ref
              .read(dashboardProvider(widget.bikeId).notifier)
              .refresh(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
            children: [
              // Bike switcher chips
              _BikeSwitcherRow(
                bikes: dash.allBikes,
                activeBikeId: widget.bikeId,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Health hero
              _HealthHero(dash: dash),

              const SizedBox(height: AppSpacing.lg),

              // Alert strip
              if (dash.healthScore.alerts.isNotEmpty)
                AlertBanner(
                  message: dash.healthScore.alerts.first.message,
                  type: dash.healthScore.alerts.first.status ==
                          HealthStatus.danger
                      ? AlertType.danger
                      : AlertType.warning,
                  onTap: () {},
                ),

              const SizedBox(height: AppSpacing.lg),

              // Quick stats 2×2
              _QuickStats(dash: dash),

              const SizedBox(height: AppSpacing.xl),

              // Fuel log button
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg),
                child: PrimaryButton(
                  label: 'Log fuel stop',
                  icon: Icons.local_gas_station_rounded,
                  onPressed: () =>
                      context.push('/garage/dashboard/${widget.bikeId}/fuel/log'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Recent activity
              if (dash.recentActivity.isNotEmpty) ...[
                SectionHeader(
                  title: 'Recent activity',
                  actionLabel: 'See all',
                  onAction: () {},
                ),
                ...dash.recentActivity.map(
                  (a) => _ActivityTile(item: a, isDark: isDark),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bike switcher row
// ---------------------------------------------------------------------------
class _BikeSwitcherRow extends ConsumerWidget {
  final List<dynamic> bikes;
  final String activeBikeId;

  const _BikeSwitcherRow(
      {required this.bikes, required this.activeBikeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: bikes.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final bike = bikes[i];
          final isActive = bike.id == activeBikeId;
          return GestureDetector(
            onTap: () {
              if (!isActive) {
                setActiveBike(ref, bike.id);
                context.go('/garage/dashboard/${bike.id}');
              }
            },
            child: AnimatedContainer(
              duration: AppDuration.normal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : bike.colour,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    bike.name,
                    style: AppTextStyles.captionMedium.copyWith(
                      color: isActive
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Health hero
// ---------------------------------------------------------------------------
class _HealthHero extends StatelessWidget {
  final DashboardState dash;
  const _HealthHero({required this.dash});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final rupeeFormat = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            HealthRing(
              score: dash.healthScore.score,
              grade: dash.healthScore.grade,
              size: 88,
            ),
            const SizedBox(width: AppSpacing.xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dash.healthScore.gradeLabel,
                      style: AppTextStyles.bodySemiBold
                          .copyWith(color: textPrimary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('This month',
                      style: AppTextStyles.caption
                          .copyWith(color: textSecondary)),
                  Text(
                    rupeeFormat.format(dash.monthTotal),
                    style: AppTextStyles.heading2
                        .copyWith(color: textPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick stats 2×2 grid
// ---------------------------------------------------------------------------
class _QuickStats extends StatelessWidget {
  final DashboardState dash;
  const _QuickStats({required this.dash});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final insuranceDays = dash.bike.insuranceExpiry
        ?.difference(now)
        .inDays;
    final lastFuelDays = dash.lastFuelLog != null
        ? now.difference(dash.lastFuelLog!.date).inDays
        : null;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Last fuel',
                  value: lastFuelDays != null
                      ? '$lastFuelDays days ago'
                      : 'Not logged',
                  trend: dash.avgMileage != null
                      ? '${dash.avgMileage!.toStringAsFixed(1)} km/L avg'
                      : null,
                  trendPositive: true,
                  icon: Icons.local_gas_station_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  label: 'Next service',
                  value: dash.nextService?.nextDueKm != null
                      ? '${dash.bike.odometerCurrent < dash.nextService!.nextDueKm! ? dash.nextService!.nextDueKm! - dash.bike.odometerCurrent : 0} km'
                      : 'Up to date',
                  icon: Icons.build_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Insurance',
                  value: insuranceDays != null
                      ? '$insuranceDays days left'
                      : 'Not set',
                  trendPositive: insuranceDays == null ||
                      insuranceDays > 30,
                  icon: Icons.verified_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  label: 'Odometer',
                  value: NumberFormat('#,##,###')
                      .format(dash.bike.odometerCurrent),
                  trend: 'km',
                  trendPositive: true,
                  icon: Icons.speed_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Activity tile
// ---------------------------------------------------------------------------
class _ActivityTile extends StatelessWidget {
  final ActivityItem item;
  final bool isDark;

  const _ActivityTile({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final (icon, title, subtitle, color) = switch (item) {
      FuelActivity(:final log) => (
          Icons.local_gas_station_rounded,
          'Fuel stop',
          log.mileageCalculated != null
              ? '${log.mileageCalculated!.toStringAsFixed(1)} km/L  ·  ${log.amount != null ? '₹${log.amount!.round()}' : ''}'
              : '${NumberFormat('#,##,###').format(log.odometer)} km',
          AppColors.primary,
        ),
      ServiceActivity(:final record) => (
          Icons.build_rounded,
          ServiceTypes.label(record.serviceType),
          '${NumberFormat('#,##,###').format(record.odometer)} km',
          isDark ? AppColors.successDark : AppColors.success,
        ),
    };

    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      title: Text(title,
          style: AppTextStyles.bodyMedium.copyWith(color: textPrimary)),
      subtitle: Text(subtitle,
          style: AppTextStyles.caption.copyWith(color: textSecondary)),
      trailing: Text(
        _relativeDate(item.date),
        style: AppTextStyles.caption.copyWith(color: textSecondary),
      ),
    );
  }

  String _relativeDate(DateTime date) {
    final days = DateTime.now().difference(date).inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days < 7) return '$days days ago';
    return DateFormat('d MMM').format(date);
  }
}

// ---------------------------------------------------------------------------
// Skeleton loading state
// ---------------------------------------------------------------------------
class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Bike switcher row
        const ShimmerBox(height: 36, borderRadius: AppRadius.full),
        const SizedBox(height: AppSpacing.lg),

        // Health hero card
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
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
              const ShimmerBox(width: 88, height: 88, borderRadius: 44),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 80, height: 16, borderRadius: 4),
                    SizedBox(height: 8),
                    ShimmerBox(width: 60, height: 12, borderRadius: 4),
                    SizedBox(height: 6),
                    ShimmerBox(width: 120, height: 24, borderRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Quick stats 2×2
        Row(children: const [
          Expanded(child: ShimmerBox(height: 80, borderRadius: 12)),
          SizedBox(width: AppSpacing.md),
          Expanded(child: ShimmerBox(height: 80, borderRadius: 12)),
        ]),
        const SizedBox(height: AppSpacing.md),
        Row(children: const [
          Expanded(child: ShimmerBox(height: 80, borderRadius: 12)),
          SizedBox(width: AppSpacing.md),
          Expanded(child: ShimmerBox(height: 80, borderRadius: 12)),
        ]),
        const SizedBox(height: AppSpacing.xl),

        // Fuel log button
        const ShimmerBox(height: 52, borderRadius: AppRadius.medium),
      ],
    );
  }
}
