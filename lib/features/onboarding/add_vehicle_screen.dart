import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/rc_lookup_service.dart';
import '../../core/services/rc_scan_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/rc_details.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/hud_panel.dart';
import '../../shared/widgets/primary_button.dart';

/// Add-vehicle hub: scan the RC card, enter details manually, or (when a lookup
/// provider is configured) look the RC up by registration number. Every path
/// ends in the same review form, [VehicleDetailsScreen].
class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _rcCtrl = TextEditingController();
  String? _error;
  bool _fetching = false;

  @override
  void dispose() {
    _rcCtrl.dispose();
    super.dispose();
  }

  void _openDetails(RcDetails details, RcPrefill source,
      {required bool prefillSuccess, String? failureReason}) {
    context.push('/onboarding/vehicle-details', extra: {
      'details': details,
      'source': source,
      'prefillSuccess': prefillSuccess,
      'failureReason': failureReason,
    });
  }

  Future<void> _lookup() async {
    final normalized = normalizeRegNumber(_rcCtrl.text);

    if (!isValidRegNumber(normalized)) {
      setState(() => _error = context.l10n.addVehicleInvalidFormat);
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

    if (result.status == RcLookupStatus.success && result.details != null) {
      _openDetails(result.details!, RcPrefill.lookup,
          prefillSuccess: true);
      return;
    }
    final l = context.l10n;
    _openDetails(RcDetails(rcNumber: normalized), RcPrefill.lookup,
        prefillSuccess: false,
        failureReason: switch (result.status) {
          RcLookupStatus.notFound => l.addVehicleNotFound,
          RcLookupStatus.apiLimitExceeded => l.addVehicleApiLimit,
          RcLookupStatus.networkError => l.addVehicleNoInternet,
          _ => l.addVehicleFetchFailed,
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
        child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xl),
              children: [
                Text(
                  l.addVehicleTitle,
                  style: AppTextStyles.heading1.copyWith(color: textPrimary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l.addVehicleHubSubtitle,
                  style: AppTextStyles.body.copyWith(color: textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),

                _OptionCard(
                  icon: Icons.document_scanner_rounded,
                  title: l.addVehicleScanTitle,
                  body: l.addVehicleScanBody,
                  highlighted: true,
                  onTap: () => context.push('/onboarding/scan-rc'),
                ),
                const SizedBox(height: AppSpacing.md),
                _OptionCard(
                  icon: Icons.edit_note_rounded,
                  title: l.addVehicleManualTitle,
                  body: l.addVehicleManualBody,
                  onTap: () => _openDetails(
                      const RcDetails(rcNumber: ''), RcPrefill.manual,
                      prefillSuccess: false),
                ),

                if (RcLookupService.isConfigured) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    l.addVehicleLookupTitle.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l.addVehicleSubtitle,
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
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'MH12DE1234',
                      hintStyle: GoogleFonts.jetBrainsMono(
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
                    l.addVehicleExamples,
                    style:
                        AppTextStyles.caption.copyWith(color: textTertiary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AnimatedSwitcher(
                    duration: AppDuration.normal,
                    child: _fetching
                        ? _LoadingPill(
                            key: const ValueKey('pill'),
                            label: l.addVehicleFetching,
                            isDark: isDark)
                        : PrimaryButton(
                            key: const ValueKey('btn'),
                            label: l.addVehicleContinue,
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
