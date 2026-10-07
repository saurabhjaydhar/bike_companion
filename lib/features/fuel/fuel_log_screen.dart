import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/parallelogram_border.dart';
import '../../data/models/fuel_log.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../features/dashboard/dashboard_provider.dart';
import '../../features/expenses/expenses_provider.dart';
import '../../features/garage/garage_provider.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';
import '../../shared/widgets/primary_button.dart';
import 'fuel_prefill.dart';
import 'fuel_provider.dart';

const _uuid = Uuid();

class FuelLogScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  const FuelLogScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<FuelLogScreen> createState() => _FuelLogScreenState();
}

class _FuelLogScreenState extends ConsumerState<FuelLogScreen> {
  final _odometerCtrl = TextEditingController();
  final _litresCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _stationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime _date = DateTime.now();
  bool _showOptional = false;
  bool _saving = false;

  FuelLog? _lastLog;
  double? _avgMileage;

  /// Usual km between fills, when the odometer was prefilled from it.
  int? _estimatedFrom;
  List<int> _amountChips = const [];

  @override
  void initState() {
    super.initState();
    _loadLastLog();
    _odometerCtrl.addListener(_onOdometerChanged);
  }

  Future<void> _loadLastLog() async {
    final repo = getIt<FuelRepository>();
    final logs = await repo.getFuelLogs(widget.vehicleId, limit: 11);
    final vehicle =
        await getIt<VehicleRepository>().getVehicleById(widget.vehicleId);
    _lastLog = logs.firstOrNull;
    _avgMileage = await repo.getAverageMileage(widget.vehicleId);
    _amountChips = amountChips(logs);

    // Start on a best guess so most fill-ups only need a nudge.
    final trip = usualTripKm(logs);
    final guess = suggestOdometer(
      vehicleOdometer: vehicle?.odometerCurrent ?? 0,
      lastLog: _lastLog,
      usualTrip: trip,
    );
    if (guess != null && _odometerCtrl.text.isEmpty) {
      _odometerCtrl.text = '$guess';
      final fromTrip = _lastLog != null &&
          (vehicle?.odometerCurrent ?? 0) <= _lastLog!.odometer;
      _estimatedFrom = fromTrip ? trip : null;
    }
    if (mounted) setState(() {});
  }

  void _onOdometerChanged() => setState(() {});

  void _nudge(int km) {
    HapticFeedback.selectionClick();
    final next = ((_currentOdometer ?? _lastLog?.odometer ?? 0) + km)
        .clamp(0, 9999999);
    _odometerCtrl.text = '$next';
  }

  void _pickAmount(int amount) {
    HapticFeedback.selectionClick();
    setState(() => _amountCtrl.text = '$amount');
  }

  /// Litres typed in, or worked out from the amount and last price.
  double? get _litres => double.tryParse(_litresCtrl.text) ?? _litresFromAmount;

  double? get _tripMileage {
    final km = _kmSinceLast, litres = _litres;
    return km != null && km > 0 && litres != null && litres > 0
        ? km / litres
        : null;
  }

  int? get _currentOdometer => int.tryParse(_odometerCtrl.text);
  int? get _kmSinceLast => (_lastLog != null && _currentOdometer != null)
      ? _currentOdometer! - _lastLog!.odometer
      : null;
  double? get _estimatedLitres =>
      (_kmSinceLast != null && _avgMileage != null && _avgMileage! > 0)
          ? _kmSinceLast! / _avgMileage!
          : null;

  /// Price per litre at the last fill-up, to work out litres from the
  /// amount paid when the user doesn't type them.
  double? get _lastPrice {
    final last = _lastLog;
    if (last?.amount == null || (last?.litres ?? 0) <= 0) return null;
    return last!.amount! / last.litres!;
  }

  double? get _litresFromAmount {
    final amount = double.tryParse(_amountCtrl.text);
    final price = _lastPrice;
    return amount != null && amount > 0 && price != null
        ? amount / price
        : null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final odometer = _currentOdometer!;
    if (_lastLog != null && odometer <= _lastLog!.odometer) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.fuelOdometerTooLow(_lastLog!.odometer)),
        backgroundColor: AppColors.danger,
      ));
      return;
    }

    setState(() => _saving = true);
    try {
      final litres = _litres;
      final amount = double.tryParse(_amountCtrl.text);
      final kmSinceLast = _kmSinceLast;
      final mileage =
          (litres != null && litres > 0 && kmSinceLast != null && kmSinceLast > 0)
              ? kmSinceLast / litres
              : null;

      final log = FuelLog(
        id: _uuid.v4(),
        vehicleId: widget.vehicleId,
        date: _date,
        odometer: odometer,
        litres: litres,
        amount: amount,
        fuelStation: _stationCtrl.text.trim().isEmpty
            ? null
            : _stationCtrl.text.trim(),
        mileageCalculated: mileage,
      );

      await getIt<FuelRepository>().insertFuelLog(log);
      await getIt<VehicleRepository>()
          .updateOdometer(widget.vehicleId, odometer);

      ref.invalidate(dashboardProvider(widget.vehicleId));
      ref.invalidate(garageProvider);
      ref.invalidate(fuelHistoryProvider(widget.vehicleId));
      ref.invalidate(expensesProvider(widget.vehicleId));

      HapticFeedback.mediumImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.l10n.fuelLogged),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ));
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _odometerCtrl.dispose();
    _litresCtrl.dispose();
    _amountCtrl.dispose();
    _stationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.dashboardFuelStop),
        actions: [
          TextButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _date = picked);
            },
            child: Text(
              DateFormat('d MMM', l.localeName).format(_date),
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            // Large odometer input
            Text(l.fuelCurrentOdometer,
                style: AppTextStyles.label
                    .copyWith(color: textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _odometerCtrl,
              // Prefilled readings only need a nudge, so keep the keyboard
              // down; an empty field gets it straight away.
              autofocus: _odometerCtrl.text.isEmpty && _lastLog == null,
              keyboardType: TextInputType.number,
              style: AppTextStyles.display
                  .copyWith(fontSize: 40, color: textPrimary),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: AppTextStyles.display.copyWith(
                    fontSize: 40,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiary),
                suffixText: 'km',
                suffixStyle: AppTextStyles.bodyMedium
                    .copyWith(color: textSecondary),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.validationRequired;
                if (int.tryParse(v) == null) return l.validationEnterNumber;
                return null;
              },
            ),
            if (_odometerCtrl.text.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  for (final km in const [-100, -10, 10, 100])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _NudgeChip(
                          label: km > 0 ? '+$km' : '−${-km}',
                          onTap: () => _nudge(km),
                        ),
                      ),
                    ),
                ],
              ),
            ],
            if (_lastLog != null)
              Padding(
                padding:
                    const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  _estimatedFrom != null
                      ? l.fuelOdometerEstimated(_estimatedFrom!)
                      : l.fuelLastEntry(_lastLog!.odometer),
                  style: AppTextStyles.caption
                      .copyWith(color: textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: AppSpacing.xl),

            // Smart estimate card
            if (_kmSinceLast != null && _kmSinceLast! > 0)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius:
                      BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                      color:
                          AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insights_rounded,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        _tripMileage != null
                            ? l.fuelTripMileage(
                                _kmSinceLast!,
                                _litres!.toStringAsFixed(1),
                                _tripMileage!.toStringAsFixed(1))
                            : _estimatedLitres != null
                                ? l.fuelKmSinceLastEstimate(_kmSinceLast!,
                                    _estimatedLitres!.toStringAsFixed(1))
                                : l.fuelKmSinceLast(_kmSinceLast!),
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.xl),

            // Amount paid — what spending tracking needs
            _FieldLabel(l.fuelAmountPaid, textSecondary),
            if (_amountChips.isNotEmpty) ...[
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final a in _amountChips)
                    ChoiceChip(
                      label: Text('₹$a'),
                      labelStyle: AppTextStyles.data.copyWith(
                        fontSize: 14,
                        color: _amountCtrl.text == '$a'
                            ? Colors.white
                            : textPrimary,
                      ),
                      selected: _amountCtrl.text == '$a',
                      showCheckmark: false,
                      onSelected: (_) => _pickAmount(a),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            TextFormField(
              controller: _amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: '0',
                prefixText: '₹ ',
                helperText: _litresFromAmount != null &&
                        _litresCtrl.text.isEmpty
                    ? l.fuelLitresFromPrice(
                        _litresFromAmount!.toStringAsFixed(1),
                        _lastPrice!.toStringAsFixed(1))
                    : null,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Optional fields toggle
            GestureDetector(
              onTap: () =>
                  setState(() => _showOptional = !_showOptional),
              child: Row(
                children: [
                  Text(l.fuelAddMoreDetails,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: textSecondary)),
                  const Spacer(),
                  Icon(
                    _showOptional
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: textSecondary,
                  ),
                ],
              ),
            ),

            if (_showOptional) ...[
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel(l.fuelLitresFilled, textSecondary),
              TextFormField(
                controller: _litresCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(hintText: '0.0', suffixText: 'L'),
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel(l.fuelStationOptional, textSecondary),
              TextFormField(
                controller: _stationCtrl,
                decoration: InputDecoration(hintText: l.fuelStationHint),
              ),
            ],


            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: l.fuelSave,
              onPressed: _save,
              isLoading: _saving,
            ),
          ],
        ),
      ),
    );
  }
}

/// A small slanted button that nudges the odometer up or down.
class _NudgeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NudgeChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.surfaceVariantDark : AppColors.track,
      shape: const ParallelogramBorder(slant: 6),
      child: InkWell(
        customBorder: const ParallelogramBorder(slant: 6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.data.copyWith(
              fontSize: 14,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _FieldLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Text(text,
            style: AppTextStyles.label.copyWith(color: color)),
      );
}
