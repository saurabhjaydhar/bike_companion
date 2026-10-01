import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/active_bike_provider.dart';
import '../../core/providers/vehicle_details_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/bike.dart';
import '../../data/models/vehicle.dart';
import '../../data/repositories/bike_repository.dart';
import '../../features/garage/garage_provider.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';
import '../../shared/widgets/primary_button.dart';

const _uuid = Uuid();

class VehicleDetailsScreen extends ConsumerStatefulWidget {
  final Vehicle vehicle;
  final bool prefillSuccess;
  final String? failureReason;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicle,
    required this.prefillSuccess,
    this.failureReason,
  });

  @override
  ConsumerState<VehicleDetailsScreen> createState() =>
      _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends ConsumerState<VehicleDetailsScreen> {
  // Text controllers — initialised once from vehicle, drive UI display.
  // onChanged keeps the notifier in sync for save.
  late final TextEditingController _manufacturerCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _modelCtrl;
  late final TextEditingController _variantCtrl;
  late final TextEditingController _fuelTypeCtrl;
  late final TextEditingController _vehicleClassCtrl;
  late final TextEditingController _engineCtrl;
  late final TextEditingController _chassisCtrl;

  // Date state — held locally and synced to notifier.
  DateTime? _registrationDate;
  DateTime? _insuranceExpiry;

  String? _brandError;
  String? _modelError;
  String? _saveError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _manufacturerCtrl = TextEditingController(text: v.manufacturer ?? '');
    _brandCtrl = TextEditingController(text: v.brand ?? '');
    _modelCtrl = TextEditingController(text: v.model ?? '');
    _variantCtrl = TextEditingController(text: v.variant ?? '');
    _fuelTypeCtrl = TextEditingController(text: v.fuelType ?? '');
    _vehicleClassCtrl = TextEditingController(text: v.vehicleClass ?? '');
    _engineCtrl = TextEditingController(text: v.engineNumber ?? '');
    _chassisCtrl = TextEditingController(text: v.chassisNumber ?? '');
    _registrationDate = v.registrationDate;
    _insuranceExpiry = v.insuranceExpiry;
  }

  @override
  void dispose() {
    _manufacturerCtrl.dispose();
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _variantCtrl.dispose();
    _fuelTypeCtrl.dispose();
    _vehicleClassCtrl.dispose();
    _engineCtrl.dispose();
    _chassisCtrl.dispose();
    super.dispose();
  }

  VehicleDetailsNotifier get _notifier =>
      ref.read(vehicleDetailsProvider(widget.vehicle).notifier);

  Future<void> _pickDate({
    required bool isRegistration,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    final initial = isRegistration
        ? (_registrationDate ?? DateTime.now())
        : (_insuranceExpiry ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null) return;

    setState(() {
      if (isRegistration) {
        _registrationDate = picked;
        _notifier.setRegistrationDate(picked);
      } else {
        _insuranceExpiry = picked;
        _notifier.setInsuranceExpiry(picked);
      }
    });
  }

  Future<void> _save() async {
    final brand = _brandCtrl.text.trim();
    final model = _modelCtrl.text.trim();

    bool hasError = false;
    if (brand.isEmpty) {
      setState(() => _brandError = context.l10n.vehicleBrandRequired);
      hasError = true;
    }
    if (model.isEmpty) {
      setState(() => _modelError = context.l10n.vehicleModelRequired);
      hasError = true;
    }
    if (hasError) return;

    setState(() {
      _brandError = null;
      _modelError = null;
      _saveError = null;
      _saving = true;
    });

    try {
      final variant = _variantCtrl.text.trim();
      final bike = Bike(
        id: _uuid.v4(),
        name: '$brand $model',
        brand: brand,
        model: model,
        variant: variant.isEmpty ? null : variant,
        colourHex: '#1A56DB',
        regNumber: widget.vehicle.rcNumber,
        purchaseDate: _registrationDate,
        odometerCurrent: 0,
        odometerOfficial: 0,
        insuranceExpiry: _insuranceExpiry,
        pucExpiry: null,
        createdAt: DateTime.now(),
      );

      await getIt<BikeRepository>().insertBike(bike);

      ref.invalidate(garageProvider);
      await setActiveBike(ref, bike.id);

      if (mounted) context.go('/garage/dashboard/${bike.id}');
    } catch (_) {
      if (mounted) {
        setState(() => _saveError = context.l10n.vehicleSaveFailed);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/garage'),
        ),
        title: Text(l.vehicleDetailsTitle,
            style: AppTextStyles.heading3.copyWith(color: textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status banner
                    _StatusBanner(
                      success: widget.prefillSuccess,
                      failureReason: widget.failureReason,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── REGISTRATION ─────────────────────────────────────
                    _SectionLabel(l.vehicleSectionRegistration),
                    const SizedBox(height: AppSpacing.md),
                    _LockedField(
                      label: l.vehicleRcNumber,
                      value: widget.vehicle.rcNumber,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── VEHICLE INFO ──────────────────────────────────────
                    _SectionLabel(l.vehicleSectionInfo),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleManufacturer,
                      controller: _manufacturerCtrl,
                      isDark: isDark,
                      onChanged: _notifier.updateManufacturer,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: '${l.fieldBrand} *',
                      controller: _brandCtrl,
                      isDark: isDark,
                      errorText: _brandError,
                      onChanged: (v) {
                        if (_brandError != null) {
                          setState(() => _brandError = null);
                        }
                        _notifier.updateBrand(v);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: '${l.fieldModel} *',
                      controller: _modelCtrl,
                      isDark: isDark,
                      errorText: _modelError,
                      onChanged: (v) {
                        if (_modelError != null) {
                          setState(() => _modelError = null);
                        }
                        _notifier.updateModel(v);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleVariant,
                      controller: _variantCtrl,
                      isDark: isDark,
                      onChanged: _notifier.updateVariant,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleFuelType,
                      controller: _fuelTypeCtrl,
                      isDark: isDark,
                      onChanged: _notifier.updateFuelType,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleClass,
                      controller: _vehicleClassCtrl,
                      isDark: isDark,
                      onChanged: _notifier.updateVehicleClass,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── REGISTRATION DETAILS ──────────────────────────────
                    _SectionLabel(l.vehicleSectionRegistrationDetails),
                    const SizedBox(height: AppSpacing.md),
                    _DatePickerField(
                      label: l.vehicleRegistrationDate,
                      value: _registrationDate,
                      isDark: isDark,
                      onTap: () => _pickDate(
                        isRegistration: true,
                        firstDate: DateTime(1980),
                        lastDate: DateTime.now(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DatePickerField(
                      label: l.fieldInsuranceExpiry,
                      value: _insuranceExpiry,
                      isDark: isDark,
                      onTap: () => _pickDate(
                        isRegistration: false,
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365)),
                        lastDate: DateTime(2050),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── IDENTIFIERS ───────────────────────────────────────
                    _SectionLabel(l.vehicleSectionIdentifiers),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleEngineNumber,
                      controller: _engineCtrl,
                      isDark: isDark,
                      onChanged: _notifier.updateEngineNumber,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleChassisNumber,
                      controller: _chassisCtrl,
                      isDark: isDark,
                      onChanged: _notifier.updateChassisNumber,
                    ),

                    if (_saveError != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        _saveError!,
                        style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.dangerDark
                              : AppColors.danger,
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),

            // Sticky bottom CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: PrimaryButton(
                label: l.vehicleSaveBike,
                onPressed: _save,
                isLoading: _saving,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status banner
// ---------------------------------------------------------------------------
class _StatusBanner extends StatelessWidget {
  final bool success;
  final String? failureReason;

  const _StatusBanner({required this.success, this.failureReason});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = success
        ? (isDark ? AppColors.successDark : AppColors.success)
        : (isDark ? AppColors.dangerDark : AppColors.danger);
    final message = success
        ? context.l10n.vehicleFetchSuccess
        : context.l10n.vehicleFetchFailure;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            success
                ? Icons.check_circle_outline_rounded
                : Icons.error_outline_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header label
// ---------------------------------------------------------------------------
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTextStyles.label.copyWith(
          color: AppColors.primary,
          letterSpacing: 1.2,
        ),
      );
}

// ---------------------------------------------------------------------------
// Standard editable form field
// ---------------------------------------------------------------------------
class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDark;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _FormField({
    required this.label,
    required this.controller,
    required this.isDark,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(errorText: errorText),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Read-only locked field (RC number)
// ---------------------------------------------------------------------------
class _LockedField extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _LockedField({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          readOnly: true,
          controller: TextEditingController(text: value),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.lock_outline_rounded,
                size: 16, color: textSecondary),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Date picker trigger field
// ---------------------------------------------------------------------------
class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final bool isDark;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.value,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
    final bg =
        isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;

    final display = value != null
        ? '${value!.day.toString().padLeft(2, '0')} / '
            '${value!.month.toString().padLeft(2, '0')} / '
            '${value!.year}'
        : context.l10n.fieldSelectDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: 14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.small),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    display,
                    style: AppTextStyles.body.copyWith(
                      color: value != null
                          ? (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary)
                          : textTertiary,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
