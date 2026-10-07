import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/active_vehicle_provider.dart';
import '../../core/services/rc_scan_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/vehicle.dart';
import '../../data/models/rc_details.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../features/dashboard/dashboard_provider.dart';
import '../../features/garage/garage_provider.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';
import '../../shared/widgets/colour_picker.dart';
import '../../shared/widgets/primary_button.dart';
import '../../core/services/analytics.dart';
import '../../shared/widgets/reminder_permission.dart';
import '../../shared/widgets/vehicle_type_picker.dart';

const _uuid = Uuid();

/// Review / edit form for a vehicle. Used for all three add-vehicle paths:
/// pre-filled from an RC scan or lookup, or empty for manual entry. With
/// [existing] it edits that vehicle instead, and offers to delete it.
class VehicleDetailsScreen extends ConsumerStatefulWidget {
  final RcDetails details;
  final RcPrefill source;
  final bool prefillSuccess;
  final String? failureReason;
  final Vehicle? existing;

  const VehicleDetailsScreen({
    super.key,
    required this.details,
    this.source = RcPrefill.lookup,
    required this.prefillSuccess,
    this.failureReason,
  }) : existing = null;

  VehicleDetailsScreen.edit(Vehicle vehicle, {super.key})
      : existing = vehicle,
        details = RcDetails(rcNumber: vehicle.regNumber),
        source = RcPrefill.manual,
        prefillSuccess = true,
        failureReason = null;

  @override
  ConsumerState<VehicleDetailsScreen> createState() =>
      _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends ConsumerState<VehicleDetailsScreen> {
  late final TextEditingController _rcCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _odometerCtrl;
  late final TextEditingController _manufacturerCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _modelCtrl;
  late final TextEditingController _fuelTypeCtrl;
  late final TextEditingController _vehicleClassCtrl;
  late final TextEditingController _engineCtrl;
  late final TextEditingController _chassisCtrl;

  String _colourHex = '#1A56DB';
  VehicleType _type = VehicleType.bike;

  /// Whether [_type] came from the RC (shown so the user can confirm it).
  bool _typeDetected = false;
  DateTime? _registrationDate;
  DateTime? _insuranceExpiry;
  DateTime? _pucExpiry;
  DateTime? _regValidity;

  String? _rcError;
  String? _brandError;
  String? _modelError;
  String? _odometerError;
  String? _saveError;
  bool _saving = false;

  /// The less-used fields (maker, class, engine and chassis numbers…) sit
  /// behind "More details" so the form starts short.
  bool _showMore = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (widget.existing case final e?) {
      _initFrom(e);
      return;
    }
    final v = widget.details;
    _rcCtrl = TextEditingController(text: v.rcNumber);
    _nameCtrl = TextEditingController();
    _odometerCtrl = TextEditingController();
    _manufacturerCtrl = TextEditingController(text: v.manufacturer ?? '');
    _brandCtrl = TextEditingController(text: v.brand ?? '');
    _modelCtrl = TextEditingController(text: v.model ?? '');
    _fuelTypeCtrl = TextEditingController(text: v.fuelType ?? '');
    _vehicleClassCtrl = TextEditingController(text: v.vehicleClass ?? '');
    _engineCtrl = TextEditingController(text: v.engineNumber ?? '');
    _chassisCtrl = TextEditingController(text: v.chassisNumber ?? '');
    _registrationDate = v.registrationDate;
    _regValidity = v.regValidity;
    _colourHex = ColourPicker.hexForName(v.colour) ?? _colourHex;
    final detected =
        vehicleTypeFromRc(vehicleClass: v.vehicleClass, model: v.model);
    _type = detected ?? VehicleType.bike;
    _typeDetected = detected != null;
    _insuranceExpiry = v.insuranceExpiry;
  }

  void _initFrom(Vehicle e) {
    _rcCtrl = TextEditingController(text: e.regNumber);
    _nameCtrl = TextEditingController(text: e.name);
    _odometerCtrl = TextEditingController(
        text: e.odometerCurrent > 0 ? '${e.odometerCurrent}' : '');
    _manufacturerCtrl = TextEditingController(text: e.manufacturer ?? '');
    _brandCtrl = TextEditingController(text: e.brand);
    _modelCtrl = TextEditingController(text: e.model);
    _fuelTypeCtrl = TextEditingController(text: e.fuelType ?? '');
    _vehicleClassCtrl = TextEditingController(text: e.vehicleClass ?? '');
    _engineCtrl = TextEditingController(text: e.engineNumber ?? '');
    _chassisCtrl = TextEditingController(text: e.chassisNumber ?? '');
    _colourHex = e.colourHex;
    _type = e.type;
    _registrationDate = e.purchaseDate;
    _insuranceExpiry = e.insuranceExpiry;
    _pucExpiry = e.pucExpiry;
    _regValidity = e.regValidity;
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final v = widget.existing!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l.garageDeleteVehicleTitle(v.name)),
        content: Text(l.garageDeleteVehicleBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: Text(l.commonCancel)),
          TextButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(l.commonDelete,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(garageProvider.notifier).deleteVehicle(v.id);
    if (ref.read(activeVehicleIdProvider) == v.id) {
      ref.read(activeVehicleIdProvider.notifier).state = null;
    }
    HapticFeedback.mediumImpact();
    // /home picks the next vehicle, or the empty garage.
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    for (final c in [
      _rcCtrl, _nameCtrl, _odometerCtrl, _manufacturerCtrl, _brandCtrl,
      _modelCtrl, _fuelTypeCtrl, _vehicleClassCtrl,
      _engineCtrl, _chassisCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<DateTime?> _pickDate({
    required DateTime? initial,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    final now = DateTime.now();
    var start = initial ?? now;
    if (start.isBefore(firstDate)) start = firstDate;
    if (start.isAfter(lastDate)) start = lastDate;
    return showDatePicker(
      context: context,
      initialDate: start,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  /// Official MoRTH SMS service: "VAHAN MH12DE1234" sent to this number replies
  /// with the vehicle's registration details.
  static const _vahanSmsNumber = '7738299899';

  Future<void> _checkOnVahan() async {
    final l = context.l10n;
    final rc = normalizeRegNumber(_rcCtrl.text);
    if (!isValidRegNumber(rc)) {
      setState(() => _rcError = l.addVehicleInvalidFormat);
      return;
    }
    // Encode the body by hand: Uri.queryParameters would turn the space
    // into '+', which some SMS apps show literally.
    final uri = Uri.parse(
        'sms:$_vahanSmsNumber?body=${Uri.encodeComponent('VAHAN $rc')}');
    var opened = false;
    try {
      opened = await launchUrl(uri);
    } catch (_) {}
    if (!opened && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.vahanSmsError)));
    }
  }

  String? _text(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  Future<void> _save() async {
    final l = context.l10n;
    final rc = normalizeRegNumber(_rcCtrl.text);
    final brand = _brandCtrl.text.trim();
    final model = _modelCtrl.text.trim();
    final odometerText = _odometerCtrl.text.trim();
    final odometer = odometerText.isEmpty ? 0 : int.tryParse(odometerText);

    setState(() {
      _rcError = rc.isEmpty
          ? l.validationRequired
          : (isValidRegNumber(rc) ? null : l.addVehicleInvalidFormat);
      _brandError = brand.isEmpty ? l.vehicleBrandRequired : null;
      _modelError = model.isEmpty ? l.vehicleModelRequired : null;
      _odometerError = odometer == null ? l.validationEnterNumber : null;
    });
    if (_rcError != null ||
        _brandError != null ||
        _modelError != null ||
        _odometerError != null) {
      return;
    }

    setState(() {
      _saveError = null;
      _saving = true;
    });

    try {
      if (widget.existing case final e?) {
        final updated = Vehicle(
          id: e.id,
          name: _text(_nameCtrl) ?? '$brand $model',
          brand: brand,
          model: model,
          type: _type,
          variant: e.variant,
          colourHex: _colourHex,
          regNumber: rc,
          purchaseDate: _registrationDate,
          odometerCurrent: odometer!,
          odometerOfficial: e.odometerOfficial,
          insuranceExpiry: _insuranceExpiry,
          pucExpiry: _pucExpiry,
          regValidity: _regValidity,
          createdAt: e.createdAt,
          monthlyBudget: e.monthlyBudget,
          yearlyBudget: e.yearlyBudget,
          manufacturer: _text(_manufacturerCtrl),
          fuelType: _text(_fuelTypeCtrl),
          vehicleClass: _text(_vehicleClassCtrl),
          engineNumber: _text(_engineCtrl)?.toUpperCase(),
          chassisNumber: _text(_chassisCtrl)?.toUpperCase(),
        );
        await getIt<VehicleRepository>().updateVehicle(updated);
        ref.invalidate(garageProvider);
        ref.invalidate(dashboardProvider(e.id));
        HapticFeedback.lightImpact();
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.vehicleUpdated)));
          context.canPop()
              ? context.pop()
              : context.go('/garage/dashboard/${e.id}');
        }
        return;
      }

      final vehicle = Vehicle(
        id: _uuid.v4(),
        name: _text(_nameCtrl) ?? '$brand $model',
        brand: brand,
        model: model,
        type: _type,
        variant: widget.details.variant,
        colourHex: _colourHex,
        regNumber: rc,
        purchaseDate: _registrationDate,
        odometerCurrent: odometer!,
        odometerOfficial: odometer,
        insuranceExpiry: _insuranceExpiry,
        pucExpiry: _pucExpiry,
        regValidity: _regValidity,
        createdAt: DateTime.now(),
        manufacturer: _text(_manufacturerCtrl),
        fuelType: _text(_fuelTypeCtrl),
        vehicleClass: _text(_vehicleClassCtrl),
        engineNumber: _text(_engineCtrl)?.toUpperCase(),
        chassisNumber: _text(_chassisCtrl)?.toUpperCase(),
      );

      await getIt<VehicleRepository>().insertVehicle(vehicle);
      Analytics.vehicleAdded(type: _type.name, source: widget.source.name);

      // First vehicle completes onboarding; otherwise the router would send
      // the user back to the welcome screen.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(SharedPrefKeys.isOnboardingDone, true);

      ref.invalidate(garageProvider);
      await setActiveVehicle(ref, vehicle.id);

      final hasDates = _insuranceExpiry != null ||
          _pucExpiry != null ||
          _regValidity != null;
      if (hasDates && mounted) await askReminderPermissionOnce(context);
      if (mounted) context.go('/garage/dashboard/${vehicle.id}');
    } catch (_) {
      if (mounted) {
        setState(() => _saveError = l.vehicleSaveFailed);
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
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/garage'),
        ),
        title: Text(_isEdit ? l.vehicleEditTitle : l.vehicleDetailsTitle,
            style: AppTextStyles.heading3.copyWith(color: textPrimary)),
        actions: [
          if (_isEdit)
            IconButton(
              tooltip: l.commonDelete,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              onPressed: _delete,
            ),
        ],
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
                    if (widget.source != RcPrefill.manual) ...[
                      _StatusBanner(
                        source: widget.source,
                        success: widget.prefillSuccess,
                        failureReason: widget.failureReason,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // ── TYPE ─────────────────────────────────────────────
                    _SectionLabel(l.vehicleTypeTitle),
                    const SizedBox(height: AppSpacing.md),
                    VehicleTypePicker(
                      selected: _type,
                      onChanged: (t) => setState(() {
                        _type = t;
                        _typeDetected = false;
                      }),
                    ),
                    if (_typeDetected) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _FieldLabel(l.vehicleTypeDetected, isDark: isDark),
                    ],
                    const SizedBox(height: AppSpacing.xl),

                    // ── REGISTRATION ─────────────────────────────────────
                    _SectionLabel(l.vehicleSectionRegistration),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: '${l.vehicleRcNumber} *',
                      controller: _rcCtrl,
                      isDark: isDark,
                      errorText: _rcError,
                      hintText: 'MH12DE1234',
                      latin: true,
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = normalizeRegNumber(newValue.text);
                          return TextEditingValue(
                            text: text,
                            selection:
                                TextSelection.collapsed(offset: text.length),
                          );
                        }),
                      ],
                      onChanged: (_) {
                        if (_rcError != null) setState(() => _rcError = null);
                      },
                    ),
                    if (!_isEdit) ...[
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: _checkOnVahan,
                      icon: const Icon(Icons.sms_rounded, size: 18),
                      label: Text(l.vahanSmsButton),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        foregroundColor: AppColors.accent,
                        side: BorderSide(
                            color: AppColors.accent.withValues(alpha: 0.6)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _FieldLabel(l.vahanSmsHint, isDark: isDark),
                    ],
                    const SizedBox(height: AppSpacing.xl),

                    // ── VEHICLE ──────────────────────────────────────────
                    _SectionLabel(l.vehicleSectionInfo),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: '${l.fieldBrand} *',
                      controller: _brandCtrl,
                      isDark: isDark,
                      errorText: _brandError,
                      onChanged: (_) {
                        if (_brandError != null) {
                          setState(() => _brandError = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: '${l.fieldModel} *',
                      controller: _modelCtrl,
                      isDark: isDark,
                      errorText: _modelError,
                      hintText: l.fieldModelHint,
                      onChanged: (_) {
                        if (_modelError != null) {
                          setState(() => _modelError = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.fieldNickname,
                      controller: _nameCtrl,
                      isDark: isDark,
                      hintText: l.fieldNicknameHint,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FieldLabel(l.fieldColour, isDark: isDark),
                    const SizedBox(height: AppSpacing.sm),
                    ColourPicker(
                      selected: _colourHex,
                      onChanged: (v) => setState(() => _colourHex = v),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.fieldCurrentOdometer,
                      controller: _odometerCtrl,
                      isDark: isDark,
                      hintText: '0',
                      errorText: _odometerError,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) {
                        if (_odometerError != null) {
                          setState(() => _odometerError = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── DUE DATES ────────────────────────────────────────
                    _SectionLabel(l.vehicleSectionDueDates),
                    const SizedBox(height: AppSpacing.md),
                    _DatePickerField(
                      label: l.fieldInsuranceExpiry,
                      value: _insuranceExpiry,
                      isDark: isDark,
                      onTap: () async {
                        final d = await _pickDate(
                            initial: _insuranceExpiry,
                            firstDate: now.subtract(const Duration(days: 365)),
                            lastDate: DateTime(2050));
                        if (d != null) setState(() => _insuranceExpiry = d);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DatePickerField(
                      label: l.fieldPucExpiry,
                      value: _pucExpiry,
                      isDark: isDark,
                      onTap: () async {
                        final d = await _pickDate(
                            initial: _pucExpiry,
                            firstDate: now.subtract(const Duration(days: 365)),
                            lastDate: DateTime(2050));
                        if (d != null) setState(() => _pucExpiry = d);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── MORE DETAILS ─────────────────────────────────────
                    _MoreToggle(
                      label: l.vehicleMoreDetails,
                      open: _showMore,
                      onTap: () => setState(() => _showMore = !_showMore),
                    ),
                    if (_showMore) ...[
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleManufacturer,
                      controller: _manufacturerCtrl,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleFuelType,
                      controller: _fuelTypeCtrl,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleClass,
                      controller: _vehicleClassCtrl,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DatePickerField(
                      label: l.vehicleRegistrationDate,
                      value: _registrationDate,
                      isDark: isDark,
                      onTap: () async {
                        final d = await _pickDate(
                            initial: _registrationDate,
                            firstDate: DateTime(1980),
                            lastDate: now);
                        if (d != null) setState(() => _registrationDate = d);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DatePickerField(
                      label: l.vehicleRegValidity,
                      value: _regValidity,
                      isDark: isDark,
                      onTap: () async {
                        final d = await _pickDate(
                            initial: _regValidity,
                            firstDate: now.subtract(const Duration(days: 365)),
                            lastDate: DateTime(2060));
                        if (d != null) setState(() => _regValidity = d);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleEngineNumber,
                      controller: _engineCtrl,
                      isDark: isDark,
                      latin: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      label: l.vehicleChassisNumber,
                      controller: _chassisCtrl,
                      isDark: isDark,
                      latin: true,
                    ),
                    ],

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
                label: l.vehicleSaveVehicle,
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
// "More details" expander
// ---------------------------------------------------------------------------
class _MoreToggle extends StatelessWidget {
  final String label;
  final bool open;
  final VoidCallback onTap;

  const _MoreToggle(
      {required this.label, required this.open, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Text(label.toUpperCase(),
                style: AppTextStyles.label.copyWith(color: color)),
            const Spacer(),
            Icon(open ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                color: color),
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
  final RcPrefill source;
  final bool success;
  final String? failureReason;

  const _StatusBanner({
    required this.source,
    required this.success,
    this.failureReason,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;
    final color = success
        ? (isDark ? AppColors.successDark : AppColors.success)
        : (isDark ? AppColors.warningDark : AppColors.warning);
    final message = switch ((source, success)) {
      (RcPrefill.scan, true) => l.vehicleScanSuccess,
      (RcPrefill.scan, false) => l.vehicleScanFailure,
      (_, true) => l.vehicleFetchSuccess,
      (_, false) => failureReason != null
          ? '$failureReason ${l.vehicleFetchFailure}'
          : l.vehicleFetchFailure,
    };

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
                : Icons.info_outline_rounded,
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
// Field label + standard editable form field
// ---------------------------------------------------------------------------
class _FieldLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _FieldLabel(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      );
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDark;
  final String? errorText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  /// Codes such as registration, engine and chassis numbers: always
  /// left-to-right, upper case, in the instrument font.
  final bool latin;

  const _FormField({
    required this.label,
    required this.controller,
    required this.isDark,
    this.errorText,
    this.hintText,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.latin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label, isDark: isDark),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textDirection: latin ? TextDirection.ltr : null,
          textCapitalization: latin
              ? TextCapitalization.characters
              : TextCapitalization.sentences,
          style: latin
              ? GoogleFonts.jetBrainsMono(
                  fontWeight: FontWeight.w600, letterSpacing: 1.2)
              : null,
          decoration: InputDecoration(errorText: errorText, hintText: hintText),
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
