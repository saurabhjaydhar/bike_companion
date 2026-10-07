import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../../l10n/l10n.dart';
import '../../../main.dart';
import '../../../shared/widgets/clay_icon.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../documents/documents_screen.dart';
import '../../expenses/quick_add_sheet.dart';
import '../../garage/garage_provider.dart';
import '../../service/service_provider.dart';
import '../../service/service_screen.dart';
import '../dashboard_provider.dart';

enum _LogKind { fuel, expense, service, odometer, document }

/// The one place to record anything for a vehicle: fuel, an expense, a
/// service, an odometer reading or a document. Each row opens the same form
/// its own tab uses, and the dashboard refreshes once it's saved.
Future<void> showLogSheet(
  BuildContext context,
  WidgetRef ref, {
  required String vehicleId,
}) async {
  final kind = await showModalBottomSheet<_LogKind>(
    context: context,
    showDragHandle: true,
    // Let the sheet grow past the default 9/16 of the screen; it scrolls
    // if five rows still don't fit (small phones, large text).
    isScrollControlled: true,
    builder: (_) => const _LogSheet(),
  );
  if (kind == null || !context.mounted) return;

  switch (kind) {
    case _LogKind.fuel:
      context.push('/garage/dashboard/$vehicleId/fuel/log');
      return;
    case _LogKind.expense:
      await showQuickAddExpense(context, ref, vehicleId: vehicleId);
    case _LogKind.service:
      // Load the vehicle's service list first so the form offers the right
      // service types and starts on the one that's due next.
      await ref.read(serviceProvider(vehicleId).future);
      if (!context.mounted) return;
      final due = ref
          .read(dashboardProvider(vehicleId))
          .valueOrNull
          ?.nextService
          ?.serviceType;
      await showLogServiceSheet(context, ref, vehicleId, due ?? '');
    case _LogKind.odometer:
      await _updateOdometer(context, ref, vehicleId);
    case _LogKind.document:
      await showAddDocumentSheet(context, ref, vehicleId);
  }
  ref.invalidate(dashboardProvider(vehicleId));
}

class _LogSheet extends StatelessWidget {
  const _LogSheet();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    Widget row(_LogKind kind, IconData icon, Color color, String title,
            String subtitle) =>
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          visualDensity: VisualDensity.compact,
          leading: ClayIcon(icon: icon, color: color, size: 42),
          title: Text(title.toUpperCase(),
              style: AppTextStyles.heading3.copyWith(color: textPrimary)),
          subtitle: Text(subtitle,
              style: AppTextStyles.caption.copyWith(color: textSecondary)),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context, kind);
          },
        );

    return SafeArea(
      child: SingleChildScrollView(
       child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.sm),
            child: Text(l.logSheetTitle.toUpperCase(),
                style: AppTextStyles.heading2.copyWith(color: textPrimary)),
          ),
          row(_LogKind.fuel, Icons.local_gas_station_rounded,
              AppColors.statFuel, l.dashboardLogFuel, l.logFuelSub),
          row(_LogKind.expense, Icons.receipt_long_rounded,
              AppColors.statCost, l.expensesAddTitle, l.logExpenseSub),
          row(_LogKind.service, Icons.build_rounded, AppColors.statService,
              l.serviceLogTitle, l.logServiceSub),
          row(_LogKind.odometer, Icons.speed_rounded, AppColors.statOdometer,
              l.logOdometerTitle, l.logOdometerSub),
          row(_LogKind.document, Icons.description_rounded,
              AppColors.warning, l.documentsAddTitle, l.logDocumentSub),
          const SizedBox(height: AppSpacing.md),
        ],
       ),
      ),
    );
  }
}

/// A one-field sheet for the current odometer reading, prefilled with the
/// last known value so a quick edit of the last digits is enough.
Future<void> _updateOdometer(
    BuildContext context, WidgetRef ref, String vehicleId) async {
  final current =
      ref.read(dashboardProvider(vehicleId)).valueOrNull?.vehicle.odometerCurrent;
  final km = await showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _OdometerSheet(current: current),
  );
  if (km == null) return;
  await getIt<VehicleRepository>().updateOdometer(vehicleId, km);
  HapticFeedback.lightImpact();
  ref.invalidate(garageProvider);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.odometerUpdated)));
  }
}

class _OdometerSheet extends StatefulWidget {
  final int? current;
  const _OdometerSheet({this.current});

  @override
  State<_OdometerSheet> createState() => _OdometerSheetState();
}

class _OdometerSheetState extends State<_OdometerSheet> {
  late final _ctrl = TextEditingController(
      text: (widget.current ?? 0) > 0 ? '${widget.current}' : '');
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final km = int.tryParse(_ctrl.text.trim());
    if (km == null || km <= 0) {
      setState(() => _error = context.l10n.odometerInvalid);
      return;
    }
    Navigator.pop(context, km);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.logOdometerTitle.toUpperCase(),
              style: AppTextStyles.heading2.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTextStyles.data,
            decoration: InputDecoration(
              labelText: l.fieldCurrentOdometer,
              suffixText: 'km',
              errorText: _error,
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(label: l.odometerSave, onPressed: _save),
        ],
      ),
    );
  }
}
