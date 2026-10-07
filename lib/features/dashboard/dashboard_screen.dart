import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/active_vehicle_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/parallelogram_border.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/health_ring.dart';
import '../../shared/widgets/hud_panel.dart';
import '../../shared/widgets/plate_badge.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/reveal.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/shimmer_box.dart';
import '../../shared/widgets/stat_card.dart';
import '../../core/services/reminder_planner.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../main.dart';
import '../../shared/widgets/reminder_permission.dart';
import '../garage/garage_provider.dart';
import 'dashboard_provider.dart';
import '../expenses/budget_sheet.dart';
import 'widgets/coming_up_card.dart';
import 'widgets/log_sheet.dart';
import 'widgets/vehicle_switcher_sheet.dart';
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

  /// Whether the LOG button shows: hidden while scrolling down.
  bool _fabVisible = true;

  bool _onScroll(UserScrollNotification n) {
    final visible = switch (n.direction) {
      ScrollDirection.reverse => false,
      ScrollDirection.forward => true,
      ScrollDirection.idle => _fabVisible,
    };
    if (visible != _fabVisible) setState(() => _fabVisible = visible);
    return false;
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
        // Tap the name to switch vehicle, add one or open the garage.
        title: dashAsync.maybeWhen(
          data: (d) => InkWell(
            onTap: () => showVehicleSwitcher(context, ref,
                vehicles: d.allVehicles, activeVehicleId: widget.vehicleId),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(d.vehicle.name.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading1),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
              ],
            ),
          ),
          orElse: () => Text(l.dashboardTitle),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      // One labelled button for logging anything; it tucks away while
      // scrolling down so it never covers a card.
      floatingActionButton: dashAsync.hasValue
          ? AnimatedSlide(
              offset: _fabVisible ? Offset.zero : const Offset(0, 2),
              duration: AppDuration.normal,
              curve: Curves.easeOutCubic,
              child: FloatingActionButton.extended(
                onPressed: () =>
                    showLogSheet(context, ref, vehicleId: widget.vehicleId),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const ParallelogramBorder(slant: 12),
                icon: const Icon(Icons.add_rounded),
                label: Text(l.logButton.toUpperCase(),
                    style: AppTextStyles.label
                        .copyWith(fontSize: 15, color: Colors.white)),
              ),
            )
          : null,
      body: NotificationListener<UserScrollNotification>(
        onNotification: _onScroll,
        child: dashAsync.when(
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

              // Quick stats 2×2
              Reveal(index: 2, child: _QuickStats(dash: dash)),

              const SizedBox(height: AppSpacing.lg),

              // Fuel log button
              Reveal(
                index: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: PrimaryButton(
                    label: l.dashboardLogFuel,
                    onPressed: () => context
                        .push('/garage/dashboard/${widget.vehicleId}/fuel/log'),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // What to act on next
              Reveal(
                index: 4,
                child: ComingUpCard(
                  dash: dash,
                  onEditDate: _editDate,
                  onTurnOnReminders: _turnOnReminders,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // This month's spending against the budget
              Reveal(
                index: 5,
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
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              // Slanted livery chips: active is carbon (light) or ignition
              // orange (dark); inactive is a flat grey plate.
              decoration: ShapeDecoration(
                color: isActive
                    ? (isDark ? AppColors.primary : AppColors.carbon)
                    : (isDark ? AppColors.surfaceVariantDark : AppColors.track),
                shape: const ParallelogramBorder(slant: 8),
              ),
              child: Text(
                vehicle.name.toUpperCase(),
                style: AppTextStyles.label.copyWith(
                  fontSize: 13,
                  letterSpacing: 1.6,
                  color: isActive
                      ? Colors.white
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary),
                ),
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
    const textSecondary = AppColors.textSecondaryDark;
    final gradeColor =
        HealthRing.gradeColor(dash.healthScore.grade, isDark: true);
    final l = context.l10n;
    final vehicle = dash.vehicle;
    final score = dash.healthScore.score;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: HudPanel(
        carbon: true,
        wideStripes: true,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Keep the header and readout clear of the stripes.
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.brand} · ${vehicle.model}'.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label
                        .copyWith(color: textSecondary, letterSpacing: 2),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PlateBadge(vehicle.regNumber, fontSize: 12),
                  const SizedBox(height: AppSpacing.md),
                  _ScoreReadout(score: score),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l.healthGradeLabel(dash.healthScore.grade).toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: gradeColor,
                      fontSize: 15,
                      letterSpacing: 2.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SegmentBar(score: score, colour: gradeColor),
          ],
        ),
      ),
    );
  }
}

/// The big health number with an orange % — counts up when it appears.
class _ScoreReadout extends StatelessWidget {
  final int score;
  const _ScoreReadout({required this.score});

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: still ? score.toDouble() : 0, end: score.toDouble()),
      duration: AppDuration.healthRing,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text.rich(
        TextSpan(children: [
          TextSpan(text: '${v.round()}'),
          TextSpan(
            text: '%',
            style: TextStyle(
                fontSize: 36, color: AppColors.primary, height: 1),
          ),
        ]),
        style: AppTextStyles.display.copyWith(
          fontSize: 104,
          height: 0.9,
          color: AppColors.textPrimaryDark,
          letterSpacing: -1,
        ),
      ),
    );
  }
}

/// Ten slanted segments, lit up to the score — a rev-counter strip.
class _SegmentBar extends StatelessWidget {
  final int score;
  final Color colour;
  const _SegmentBar({required this.score, required this.colour});

  @override
  Widget build(BuildContext context) {
    final lit = (score / 10).round();
    return Row(
      children: [
        for (var i = 0; i < 10; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 5),
              child: Transform(
                transform: Matrix4.skewX(-0.35),
                alignment: Alignment.center,
                child: Container(
                  height: 9,
                  color: i < lit ? colour : const Color(0xFF2A2C31),
                ),
              ),
            ),
          ),
      ],
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
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  label: l.dashboardNextService,
                  value: dash.nextService?.nextDueKm != null
                      ? '${dash.vehicle.odometerCurrent < dash.nextService!.nextDueKm! ? dash.nextService!.nextDueKm! - dash.vehicle.odometerCurrent : 0} km'
                      : l.dashboardUpToDate,
                  emphasis: true,
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
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  label: l.fieldOdometer,
                  value: '${NumberFormat('#,##,###').format(dash.vehicle.odometerCurrent)} km',
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
