import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/fuel_log.dart';
import '../../data/repositories/bike_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../features/dashboard/dashboard_provider.dart';
import '../../features/garage/garage_provider.dart';
import '../../main.dart';
import '../../shared/widgets/primary_button.dart';
import 'fuel_provider.dart';

const _uuid = Uuid();

class FuelLogScreen extends ConsumerStatefulWidget {
  final String bikeId;
  const FuelLogScreen({super.key, required this.bikeId});

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

  @override
  void initState() {
    super.initState();
    _loadLastLog();
    _odometerCtrl.addListener(_onOdometerChanged);
  }

  Future<void> _loadLastLog() async {
    final repo = getIt<FuelRepository>();
    _lastLog = await repo.getLastFuelLog(widget.bikeId);
    _avgMileage = await repo.getAverageMileage(widget.bikeId);
    if (mounted) setState(() {});
  }

  void _onOdometerChanged() => setState(() {});

  int? get _currentOdometer => int.tryParse(_odometerCtrl.text);
  int? get _kmSinceLast => (_lastLog != null && _currentOdometer != null)
      ? _currentOdometer! - _lastLog!.odometer
      : null;
  double? get _estimatedLitres =>
      (_kmSinceLast != null && _avgMileage != null && _avgMileage! > 0)
          ? _kmSinceLast! / _avgMileage!
          : null;

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final odometer = _currentOdometer!;
    if (_lastLog != null && odometer <= _lastLog!.odometer) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Odometer must be greater than last entry (${_lastLog!.odometer} km)'),
        backgroundColor: AppColors.danger,
      ));
      return;
    }

    setState(() => _saving = true);
    try {
      final litres = double.tryParse(_litresCtrl.text);
      final amount = double.tryParse(_amountCtrl.text);
      final kmSinceLast = _kmSinceLast;
      final mileage =
          (litres != null && litres > 0 && kmSinceLast != null && kmSinceLast > 0)
              ? kmSinceLast / litres
              : null;

      final log = FuelLog(
        id: _uuid.v4(),
        bikeId: widget.bikeId,
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
      await getIt<BikeRepository>()
          .updateOdometer(widget.bikeId, odometer);

      ref.invalidate(dashboardProvider(widget.bikeId));
      ref.invalidate(garageProvider);
      ref.invalidate(fuelHistoryProvider(widget.bikeId));

      HapticFeedback.mediumImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Fuel stop logged!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
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
    final border = isDark ? AppColors.borderDark : AppColors.border;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel stop'),
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
              DateFormat('d MMM').format(_date),
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
            Text('Current odometer',
                style: AppTextStyles.label
                    .copyWith(color: textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _odometerCtrl,
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
                if (v == null || v.trim().isEmpty) return 'Required';
                if (int.tryParse(v) == null) return 'Enter a number';
                return null;
              },
            ),
            if (_lastLog != null)
              Padding(
                padding:
                    const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'Last entry: ${_lastLog!.odometer} km',
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
                        _estimatedLitres != null
                            ? '$_kmSinceLast km since last fill · ~${_estimatedLitres!.toStringAsFixed(1)} L estimated'
                            : '$_kmSinceLast km since last fill',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.xl),

            // Optional fields toggle
            GestureDetector(
              onTap: () =>
                  setState(() => _showOptional = !_showOptional),
              child: Row(
                children: [
                  Text('Add more details',
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
              _FieldLabel('Litres filled', textSecondary),
              TextFormField(
                controller: _litresCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(hintText: '0.0', suffixText: 'L'),
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel('Amount paid', textSecondary),
              TextFormField(
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                    hintText: '0', prefixText: '₹ '),
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel('Fuel station (optional)', textSecondary),
              TextFormField(
                controller: _stationCtrl,
                decoration: const InputDecoration(
                    hintText: 'HP, Indian Oil, Bharat...'),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Receipt scan placeholder
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Receipt scan coming soon!')),
                );
              },
              icon: const Icon(Icons.camera_alt_outlined, size: 18),
              label: const Text('Scan receipt'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                side: BorderSide(color: border),
                foregroundColor: textSecondary,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Save fuel stop',
              onPressed: _save,
              isLoading: _saving,
            ),
          ],
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
