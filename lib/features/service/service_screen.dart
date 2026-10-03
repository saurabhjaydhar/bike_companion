import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/health_score.dart';
import '../../data/models/service_record.dart';
import '../../features/dashboard/dashboard_provider.dart';
import '../../features/garage/garage_provider.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/empty_state.dart';
import 'service_provider.dart';

const _uuid = Uuid();

class ServiceScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  const ServiceScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.expenseService),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l.serviceDueSoon),
            Tab(text: l.serviceHistory),
          ],
          labelStyle: AppTextStyles.bodySemiBold,
          unselectedLabelStyle: AppTextStyles.body,
          labelColor: AppColors.primary,
          unselectedLabelColor:
              isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: ref.watch(serviceProvider(widget.vehicleId)).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (state) => TabBarView(
              controller: _tabs,
              children: [
                _DueSoonTab(
                    vehicleId: widget.vehicleId, items: state.dueItems, ref: ref),
                _HistoryTab(history: state.history),
              ],
            ),
          ),
    );
  }
}

// ---------------------------------------------------------------------------
// Due soon tab
// ---------------------------------------------------------------------------
class _DueSoonTab extends StatelessWidget {
  final String vehicleId;
  final List<ServiceItem> items;
  final WidgetRef ref;

  const _DueSoonTab(
      {required this.vehicleId, required this.items, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: items.length,
      separatorBuilder: (_, i) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final item = items[i];
        return _ServiceRow(
          item: item,
          onTap: () => _showLogSheet(context, ref, vehicleId, item.type),
        );
      },
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onTap;

  const _ServiceRow({required this.item, required this.onTap});

  IconData _icon(String type) {
    switch (type) {
      case ServiceTypes.oilChange:
      case ServiceTypes.oilFilter:
        return Icons.opacity_rounded;
      case ServiceTypes.airFilter:
        return Icons.air_rounded;
      case ServiceTypes.chainClean:
      case ServiceTypes.chainLube:
        return Icons.link_rounded;
      case ServiceTypes.brakePads:
        return Icons.disc_full_rounded;
      case ServiceTypes.tyres:
        return Icons.radio_button_unchecked_rounded;
      case ServiceTypes.battery:
        return Icons.battery_full_rounded;
      case ServiceTypes.coolant:
        return Icons.water_drop_rounded;
      default:
        return Icons.build_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l = context.l10n;

    final statusColor = switch (item.status) {
      HealthStatus.good =>
        isDark ? AppColors.successDark : AppColors.success,
      HealthStatus.warning =>
        isDark ? AppColors.warningDark : AppColors.warning,
      HealthStatus.danger =>
        isDark ? AppColors.dangerDark : AppColors.danger,
    };

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(_icon(item.type), size: 20, color: statusColor),
      ),
      title: Text(l.serviceTypeLabel(item.type),
          style: AppTextStyles.bodyMedium.copyWith(color: textPrimary)),
      subtitle: Text(
        item.factor?.localizedMessage(l) ??
            (item.lastRecord != null
                ? l.serviceLast(DateFormat('d MMM y', l.localeName)
                    .format(item.lastRecord!.date))
                : l.dashboardNotLogged),
        style: AppTextStyles.caption.copyWith(color: textSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(item.statusLabel(l),
                style: AppTextStyles.label.copyWith(color: statusColor)),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// History tab
// ---------------------------------------------------------------------------
class _HistoryTab extends StatelessWidget {
  final List<ServiceRecord> history;

  const _HistoryTab({required this.history});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (history.isEmpty) {
      return EmptyState(
        icon: Icons.build_rounded,
        heading: l.serviceEmptyTitle,
        body: l.serviceEmptyBody,
      );
    }

    final byYear = <int, List<ServiceRecord>>{};
    for (final r in history) {
      byYear.putIfAbsent(r.date.year, () => []).add(r);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: byYear.entries
          .toList()
          .reversed
          .expand((entry) => [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text('${entry.key}',
                      style: AppTextStyles.heading3
                          .copyWith(color: textSecondary)),
                ),
                ...entry.value.map((r) => Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius:
                            BorderRadius.circular(AppRadius.medium),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.serviceTypeLabel(r.serviceType),
                                    style: AppTextStyles.bodyMedium),
                                Text(
                                  DateFormat('d MMM y', l.localeName).format(r.date),
                                  style: AppTextStyles.caption
                                      .copyWith(color: textSecondary),
                                ),
                                if (r.notes != null)
                                  Text(r.notes!,
                                      style: AppTextStyles.caption
                                          .copyWith(color: textSecondary)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${NumberFormat('#,##,###').format(r.odometer)} km',
                                style: AppTextStyles.captionMedium,
                              ),
                              if (r.cost != null)
                                Text(
                                  '₹${r.cost!.round()}',
                                  style: AppTextStyles.caption
                                      .copyWith(color: textSecondary),
                                ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ])
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Log service bottom sheet
// ---------------------------------------------------------------------------
void _showLogSheet(
    BuildContext context, WidgetRef ref, String vehicleId, String preselectedType) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large)),
    ),
    builder: (_) => _LogServiceSheet(
      vehicleId: vehicleId,
      preselectedType: preselectedType,
      ref: ref,
    ),
  );
}

class _LogServiceSheet extends StatefulWidget {
  final String vehicleId;
  final String preselectedType;
  final WidgetRef ref;

  const _LogServiceSheet({
    required this.vehicleId,
    required this.preselectedType,
    required this.ref,
  });

  @override
  State<_LogServiceSheet> createState() => _LogServiceSheetState();
}

class _LogServiceSheetState extends State<_LogServiceSheet> {
  late String _type;

  /// Service types for this vehicle: no chain items for cars and scooters.
  late final List<String> _types;
  final DateTime _date = DateTime.now();
  final _odometerCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _shopCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _types = widget.ref
            .read(serviceProvider(widget.vehicleId))
            .valueOrNull
            ?.vehicleType
            .maintenance
            .serviceTypes ??
        ServiceTypes.all;
    _type = _types.contains(widget.preselectedType)
        ? widget.preselectedType
        : _types.first;
  }

  @override
  void dispose() {
    _odometerCtrl.dispose();
    _costCtrl.dispose();
    _shopCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_odometerCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final record = ServiceRecord(
        id: _uuid.v4(),
        vehicleId: widget.vehicleId,
        date: _date,
        serviceType: _type,
        odometer: int.parse(_odometerCtrl.text),
        cost: double.tryParse(_costCtrl.text),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      await widget.ref
          .read(serviceProvider(widget.vehicleId).notifier)
          .addService(record);
      widget.ref.invalidate(dashboardProvider(widget.vehicleId));
      widget.ref.invalidate(garageProvider);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l = context.l10n;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg,
          AppSpacing.xl, MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l.serviceLogTitle, style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),

          Text(l.serviceType,
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: const InputDecoration(),
            items: _types
                .map((t) => DropdownMenuItem(
                    value: t, child: Text(l.serviceTypeLabel(t))))
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          const SizedBox(height: AppSpacing.lg),

          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.serviceOdometerKm,
                      style:
                          AppTextStyles.label.copyWith(color: textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _odometerCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '0'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.serviceCost,
                      style:
                          AppTextStyles.label.copyWith(color: textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _costCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(hintText: '0'),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),

          Text(l.fieldNotesOptional,
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _notesCtrl,
            decoration: InputDecoration(hintText: l.serviceNotesHint),
          ),
          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(l.serviceSave),
            ),
          ),
        ],
      ),
    );
  }
}
