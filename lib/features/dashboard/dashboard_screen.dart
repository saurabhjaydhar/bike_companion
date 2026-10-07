import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/active_vehicle_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/health_ring.dart';
import '../../shared/widgets/hud_panel.dart';
import '../../shared/widgets/plate_badge.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/reveal.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/shimmer_box.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/vehicle_avatar.dart';
import '../../core/services/reminder_planner.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../main.dart';
import '../../shared/widgets/reminder_permission.dart';
import '../garage/garage_provider.dart';
import 'dashboard_provider.dart';
import '../expenses/budget_sheet.dart';
import '../expenses/quick_add_sheet.dart';
import 'widgets/coming_up_card.dart';
import 'widgets/spending_card.dart';
import '../../shared/widgets/clay_icon.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  /// A [DueKind] name ("insurance", "puc", "registration") whose date
  /// editor opens on arrival — set when coming from a reminder.
  final String? edit;

  const DashboardScreen({super.key, required this.vehicleId, this.edit});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    // Set this vehicle as active when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setActiveVehicle(ref, widget.vehicleId);
      _openRequestedEditor();
    });
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.edit != oldWidget.edit) _openRequestedEditor();
  }

  Future<void> _openRequestedEditor() async {
    final kind =
        DueKind.values.where((k) => k.name == widget.edit).firstOrNull;
    if (kind == null) return;
    await ref.read(dashboardProvider(widget.vehicleId).future);
    if (mounted) await _editDate(kind);
  }

  /// Date picker for one of the vehicle's own dates; saving re-plans its
  /// reminders.
  Future<void> _editDate(DueKind kind) async {
    final dash = ref.read(dashboardProvider(widget.vehicleId)).valueOrNull;
    if (dash == null) return;
    final l = context.l10n;
    final v = dash.vehicle;
    final current = switch (kind) {
      DueKind.insurance => v.insuranceExpiry,
      DueKind.puc => v.pucExpiry,
      DueKind.registration => v.regValidity,
      _ => null,
    };
    final label = switch (kind) {
      DueKind.insurance => l.docInsurance,
      DueKind.puc => l.docPuc,
      _ => l.dueRegistration,
    };
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current != null && current.isAfter(now) ? current : now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(2060),
      helpText: l.dueValidUntil(label),
    );
    if (picked == null || !mounted) return;

    final updated = switch (kind) {
      DueKind.insurance => v.copyWith(insuranceExpiry: picked),
      DueKind.puc => v.copyWith(pucExpiry: picked),
      _ => v.copyWith(regValidity: picked),
    };
    await getIt<VehicleRepository>().updateVehicle(updated);
    HapticFeedback.lightImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.dueUpdated)));
    await ref.read(dashboardProvider(widget.vehicleId).notifier).refresh();
    ref.invalidate(garageProvider);
    if (mounted) await askReminderPermissionOnce(context);
  }

  Future<void> _turnOnReminders() async {
    await turnOnReminders(context);
    await ref.read(dashboardProvider(widget.vehicleId).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final dashAsync = ref.watch(dashboardProvider(widget.vehicleId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/garage')),
        title: dashAsync.maybeWhen(
          data: (d) => Text(d.vehicle.name),
          orElse: () => Text(l.dashboardTitle),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      floatingActionButton: dashAsync.hasValue
          ? FloatingActionButton(
              onPressed: () => showQuickAddExpense(context, ref,
                  vehicleId: widget.vehicleId),
              backgroundColor: AppColors.primary,
              tooltip: l.expensesAddTitle,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: dashAsync.when(
        loading: () => const _DashboardSkeleton(),
        error: (e, _) => Center(child: Text('$e')),
        data: (dash) => RefreshIndicator(
          onRefresh: () => ref
              .read(dashboardProvider(widget.vehicleId).notifier)
              .refresh(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
            children: [
              // Vehicle switcher chips
              Reveal(
                child: _VehicleSwitcherRow(
                  vehicles: dash.allVehicles,
                  activeVehicleId: widget.vehicleId,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Health hero
              Reveal(index: 1, child: _HealthHero(dash: dash)),

              const SizedBox(height: AppSpacing.lg),

              // What to act on next
              Reveal(
                index: 2,
                child: ComingUpCard(
                  dash: dash,
                  onEditDate: _editDate,
                  onTurnOnReminders: _turnOnReminders,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // This month's spending against the budget
              Reveal(
                index: 3,
                child: SpendingCard(
                  spent: dash.monthTotal,
                  budget: dash.vehicle.monthlyBudget,
                  onOpen: () => context.go('/expenses/${widget.vehicleId}'),
                  onSetBudget: () => showBudgetSheet(
                    context,
                    ref,
                    vehicle: dash.vehicle,
                    suggestion: dash.budgetSuggestion,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Quick stats 2×2
              Reveal(index: 4, child: _QuickStats(dash: dash)),

              const SizedBox(height: AppSpacing.xl),

              // Fuel log button
              Reveal(
                index: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: PrimaryButton(
                    label: l.dashboardLogFuel,
                    icon: Icons.local_gas_station_rounded,
                    onPressed: () => context
                        .push('/garage/dashboard/${widget.vehicleId}/fuel/log'),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Recent activity
              if (dash.recentActivity.isNotEmpty) ...[
                SectionHeader(
                  title: l.dashboardRecentActivity,
                  actionLabel: l.dashboardSeeAll,
                  onAction: () =>
                      context.go('/expenses/${widget.vehicleId}'),
                ),
                Reveal(
                  index: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    child: HudGroup(
                      dividerIndent: 68,
                      children: [
                        for (final a in dash.recentActivity)
                          _ActivityTile(item: a, isDark: isDark),
                      ],
                    ),
                  ),
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
// Vehicle switcher row
// ---------------------------------------------------------------------------
class _VehicleSwitcherRow extends ConsumerWidget {
  final List<dynamic> vehicles;
  final String activeVehicleId;

  const _VehicleSwitcherRow(
      {required this.vehicles, required this.activeVehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    // Tall enough that the chips' shadows aren't clipped by the list.
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.sm),
        itemCount: vehicles.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final vehicle = vehicles[i];
          final isActive = vehicle.id == activeVehicleId;
          return GestureDetector(
            onTap: () {
              if (!isActive) {
                setActiveVehicle(ref, vehicle.id);
                context.go('/garage/dashboard/${vehicle.id}');
              }
            },
            child: AnimatedContainer(
              duration: AppDuration.normal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: ShapeDecoration(
                // Active: ignition gradient in dark mode, carbon in light.
                color: isActive
                    ? (isDark ? null : AppColors.carbon)
                    : surface,
                gradient: isActive && isDark
                    ? const LinearGradient(colors: AppColors.ignitionGradient)
                    : null,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.small),
                  side: BorderSide(
                    color: isActive
                        ? (isDark ? AppColors.primary : AppColors.carbon)
                        : border,
                  ),
                ),
                shadows: isActive
                    ? (isDark
                        ? [
                            BoxShadow(
                              color:
                                  AppColors.primary.withValues(alpha: 0.45),
                              blurRadius: 14,
                              spreadRadius: -4,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : AppShadows.raised(false))
                    : AppShadows.card(isDark),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? (isDark ? Colors.white : AppColors.primary)
                          : vehicle.colour,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    vehicle.name,
                    style: AppTextStyles.label.copyWith(
                      fontSize: 13,
                      color: isActive ? Colors.white : textPrimary,
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
    // Carbon panel: always drawn light-on-dark, whatever the page theme.
    final textSecondary = AppColors.textSecondaryDark;
    final gradeColor =
        HealthRing.gradeColor(dash.healthScore.grade, isDark: true);
    final l = context.l10n;
    final vehicle = dash.vehicle;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: HudPanel(
        carbon: true,
        glow: gradeColor,
        sheen: true,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
        child: Column(
          children: [
            Row(
              children: [
                VehicleAvatar(
                  colour: vehicle.colour,
                  size: 36,
                  type: vehicle.type,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '${vehicle.brand} ${vehicle.model}'.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(color: textSecondary),
                  ),
                ),
                PlateBadge(vehicle.regNumber),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            HealthRing(
              score: dash.healthScore.score,
              grade: dash.healthScore.grade,
              size: 184,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: gradeColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border:
                    Border.all(color: gradeColor.withValues(alpha: 0.35)),
              ),
              child: Text(
                l.healthGradeLabel(dash.healthScore.grade),
                textAlign: TextAlign.center,
                style: AppTextStyles.heading3.copyWith(color: gradeColor),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final lastFuelDays = dash.lastFuelLog != null
        ? now.difference(dash.lastFuelLog!.date).inDays
        : null;
    final l = context.l10n;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          IntrinsicHeight(child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatCard(
                  label: l.dashboardLastFuel,
                  value: lastFuelDays != null
                      ? l.commonDaysAgo(lastFuelDays)
                      : l.dashboardNotLogged,
                  trend: dash.avgMileage != null
                      ? l.dashboardAvgMileage(
                          dash.avgMileage!.toStringAsFixed(1))
                      : null,
                  trendPositive: true,
                  icon: Icons.local_gas_station_outlined,
                  color: AppColors.statFuel,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  label: l.dashboardNextService,
                  value: dash.nextService?.nextDueKm != null
                      ? '${dash.vehicle.odometerCurrent < dash.nextService!.nextDueKm! ? dash.nextService!.nextDueKm! - dash.vehicle.odometerCurrent : 0} km'
                      : l.dashboardUpToDate,
                  icon: Icons.build_outlined,
                  color: isDark ? AppColors.successDark : AppColors.statService,
                ),
              ),
            ],
          )),
          const SizedBox(height: AppSpacing.md),
          IntrinsicHeight(child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatCard(
                  label: l.expensesCostPerKm,
                  value: dash.costPerKm != null
                      ? '₹${dash.costPerKm!.toStringAsFixed(2)}'
                      : '—',
                  icon: Icons.route_outlined,
                  color: AppColors.statCost,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  label: l.fieldOdometer,
                  value: NumberFormat('#,##,###')
                      .format(dash.vehicle.odometerCurrent),
                  trend: 'km',
                  trendPositive: true,
                  icon: Icons.speed_outlined,
                  color: isDark ? AppColors.accent : AppColors.statOdometer,
                ),
              ),
            ],
          )),
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
    final l = context.l10n;

    final (icon, title, subtitle, color) = switch (item) {
      FuelActivity(:final log) => (
          Icons.local_gas_station_rounded,
          l.dashboardFuelStop,
          log.mileageCalculated != null
              ? '${log.mileageCalculated!.toStringAsFixed(1)} km/L  ·  ${log.amount != null ? '₹${log.amount!.round()}' : ''}'
              : '${NumberFormat('#,##,###').format(log.odometer)} km',
          AppColors.primary,
        ),
      ServiceActivity(:final record) => (
          Icons.build_rounded,
          l.serviceTypeLabel(record.serviceType),
          '${NumberFormat('#,##,###').format(record.odometer)} km',
          isDark ? AppColors.successDark : AppColors.success,
        ),
    };

    return ListTile(
      leading: ClayIcon(icon: icon, color: color, size: 38),
      title: Text(title,
          style: AppTextStyles.bodyMedium.copyWith(color: textPrimary)),
      subtitle: Text(subtitle,
          style: AppTextStyles.caption.copyWith(color: textSecondary)),
      trailing: Text(
        _relativeDate(l, item.date),
        style: AppTextStyles.caption.copyWith(color: textSecondary),
      ),
    );
  }

  String _relativeDate(AppLocalizations l, DateTime date) {
    final days = DateTime.now().difference(date).inDays;
    if (days == 0) return l.commonToday;
    if (days == 1) return l.commonYesterday;
    if (days < 7) return l.commonDaysAgo(days);
    return DateFormat('d MMM', l.localeName).format(date);
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
        // Vehicle switcher row
        const ShimmerBox(height: 36, borderRadius: AppRadius.full),
        const SizedBox(height: AppSpacing.lg),

        // Health hero card
        HudPanel(
          padding: const EdgeInsets.all(AppSpacing.xl),
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
          Expanded(child: ShimmerBox(height: 80, borderRadius: AppRadius.large)),
          SizedBox(width: AppSpacing.md),
          Expanded(child: ShimmerBox(height: 80, borderRadius: AppRadius.large)),
        ]),
        const SizedBox(height: AppSpacing.md),
        Row(children: const [
          Expanded(child: ShimmerBox(height: 80, borderRadius: AppRadius.large)),
          SizedBox(width: AppSpacing.md),
          Expanded(child: ShimmerBox(height: 80, borderRadius: AppRadius.large)),
        ]),
        const SizedBox(height: AppSpacing.xl),

        // Fuel log button
        const ShimmerBox(height: 52, borderRadius: AppRadius.medium),
      ],
    );
  }
}
