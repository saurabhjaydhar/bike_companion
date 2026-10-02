import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/rc_lookup_service.dart';
import '../../core/services/rc_scan_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/vehicle.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/hud_panel.dart';
import '../../shared/widgets/primary_button.dart';

/// Add-bike hub: scan the RC card, enter details manually, or (when a lookup
/// provider is configured) look the RC up by registration number. Every path
/// ends in the same review form, [VehicleDetailsScreen].
class AddBikeScreen extends ConsumerStatefulWidget {
  const AddBikeScreen({super.key});

  @override
  ConsumerState<AddBikeScreen> createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends ConsumerState<AddBikeScreen> {
  final _rcCtrl = TextEditingController();
  String? _error;
  bool _fetching = false;
  bool _scanning = false;
  bool _useGemini = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        setState(() => _useGemini =
            prefs.getBool(SharedPrefKeys.rcScanUseGemini) ?? false);
      }
    });
  }

  @override
  void dispose() {
    _rcCtrl.dispose();
    super.dispose();
  }

  void _openDetails(Vehicle vehicle, VehiclePrefill source,
      {required bool prefillSuccess, String? failureReason}) {
    context.push('/onboarding/vehicle-details', extra: {
      'vehicle': vehicle,
      'source': source,
      'prefillSuccess': prefillSuccess,
      'failureReason': failureReason,
    });
  }

  Future<void> _setUseGemini(bool value) async {
    setState(() => _useGemini = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKeys.rcScanUseGemini, value);
  }

  Future<void> _scan(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 2048,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;

    HapticFeedback.lightImpact();
    setState(() => _scanning = true);
    final result = await ref
        .read(rcScanServiceProvider)
        .scan(file.path, allowCloud: _useGemini);
    if (!mounted) return;
    setState(() => _scanning = false);

    _openDetails(
      result.vehicle ?? const Vehicle(rcNumber: ''),
      VehiclePrefill.scan,
      prefillSuccess: result.found,
    );
  }

  void _showScanSheet() {
    final l = context.l10n;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_rounded,
                      color: AppColors.primary),
                  title: Text(l.scanTakePhoto),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _scan(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded,
                      color: AppColors.primary),
                  title: Text(l.scanChooseGallery),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _scan(ImageSource.gallery);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  value: _useGemini,
                  activeThumbColor: AppColors.primary,
                  secondary: const Icon(Icons.auto_awesome_rounded,
                      color: AppColors.accent),
                  title: Text(l.scanUseGemini),
                  subtitle: Text(l.scanUseGeminiBody),
                  isThreeLine: true,
                  onChanged: (v) {
                    _setUseGemini(v);
                    setSheetState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _lookup() async {
    final normalized = normalizeRegNumber(_rcCtrl.text);

    if (!isValidRegNumber(normalized)) {
      setState(() => _error = context.l10n.addBikeInvalidFormat);
      return;
    }

    setState(() {
      _error = null;
      _fetching = true;
    });

    final result =
        await ref.read(rcLookupServiceProvider).lookup(normalized);

    if (!mounted) return;
    setState(() => _fetching = false);

    if (result.status == RcLookupStatus.success && result.vehicle != null) {
      _openDetails(result.vehicle!, VehiclePrefill.lookup,
          prefillSuccess: true);
      return;
    }
    final l = context.l10n;
    _openDetails(Vehicle(rcNumber: normalized), VehiclePrefill.lookup,
        prefillSuccess: false,
        failureReason: switch (result.status) {
          RcLookupStatus.notFound => l.addBikeNotFound,
          RcLookupStatus.apiLimitExceeded => l.addBikeApiLimit,
          RcLookupStatus.networkError => l.addBikeNoInternet,
          _ => l.addBikeFetchFailed,
        });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/garage'),
        ),
      ),
      body: SafeArea(
        child: _scanning
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: _LoadingPill(
                      label: l.scanReading, isDark: isDark),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xl),
                children: [
                  Text(
                    l.addBikeTitle,
                    style: AppTextStyles.heading1.copyWith(color: textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.addBikeHubSubtitle,
                    style: AppTextStyles.body.copyWith(color: textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  _OptionCard(
                    icon: Icons.document_scanner_rounded,
                    title: l.addBikeScanTitle,
                    body: l.addBikeScanBody,
                    highlighted: true,
                    onTap: _showScanSheet,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _OptionCard(
                    icon: Icons.edit_note_rounded,
                    title: l.addBikeManualTitle,
                    body: l.addBikeManualBody,
                    onTap: () => _openDetails(
                        const Vehicle(rcNumber: ''), VehiclePrefill.manual,
                        prefillSuccess: false),
                  ),

                  if (RcLookupService.isConfigured) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      l.addBikeLookupTitle.toUpperCase(),
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.addBikeSubtitle,
                      style:
                          AppTextStyles.caption.copyWith(color: textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _rcCtrl,
                      enabled: !_fetching,
                      // Registration numbers are Latin, even in RTL languages.
                      textDirection: TextDirection.ltr,
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
                      style: GoogleFonts.chakraPetch(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'MH12DE1234',
                        hintStyle: GoogleFonts.chakraPetch(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: textTertiary,
                        ),
                        errorText: _error,
                      ),
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                      },
                      onSubmitted: (_) {
                        if (!_fetching) _lookup();
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l.addBikeExamples,
                      style:
                          AppTextStyles.caption.copyWith(color: textTertiary),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AnimatedSwitcher(
                      duration: AppDuration.normal,
                      child: _fetching
                          ? _LoadingPill(
                              key: const ValueKey('pill'),
                              label: l.addBikeFetching,
                              isDark: isDark)
                          : PrimaryButton(
                              key: const ValueKey('btn'),
                              label: l.addBikeContinue,
                              isOutlined: true,
                              onPressed: _lookup,
                            ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Option card
// ---------------------------------------------------------------------------
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final bool highlighted;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final colour = highlighted ? AppColors.primary : AppColors.accent;

    return HudPanel(
      glow: highlighted ? AppColors.primary : null,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colour.withValues(alpha: 0.32),
                  colour.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(color: colour.withValues(alpha: 0.5)),
            ),
            child: Icon(icon, color: colour, size: 26),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        AppTextStyles.heading3.copyWith(color: textPrimary)),
                const SizedBox(height: 2),
                Text(body,
                    style:
                        AppTextStyles.caption.copyWith(color: textSecondary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: textSecondary),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading pill — shown in place of the CTA while the API call is in flight
// ---------------------------------------------------------------------------
class _LoadingPill extends StatelessWidget {
  final String label;
  final bool isDark;
  const _LoadingPill({super.key, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
