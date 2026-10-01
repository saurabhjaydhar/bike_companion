import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/rc_lookup_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/vehicle.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/primary_button.dart';

final _rcRegex = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{1,4}$');

class AddBikeScreen extends ConsumerStatefulWidget {
  const AddBikeScreen({super.key});

  @override
  ConsumerState<AddBikeScreen> createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends ConsumerState<AddBikeScreen> {
  final _rcCtrl = TextEditingController();
  String? _error;
  bool _fetching = false;

  @override
  void dispose() {
    _rcCtrl.dispose();
    super.dispose();
  }

  String _normalize(String raw) =>
      raw.replaceAll(RegExp(r'[\s\-]'), '').toUpperCase();

  Future<void> _continue() async {
    final normalized = _normalize(_rcCtrl.text);

    if (!_rcRegex.hasMatch(normalized)) {
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

    final Vehicle vehicle;
    final bool prefillSuccess;
    String? failureReason;

    if (result.status == RcLookupStatus.success && result.vehicle != null) {
      vehicle = result.vehicle!;
      prefillSuccess = true;
    } else {
      vehicle = Vehicle(rcNumber: normalized);
      prefillSuccess = false;
      final l = context.l10n;
      failureReason = switch (result.status) {
        RcLookupStatus.notFound => l.addBikeNotFound,
        RcLookupStatus.apiLimitExceeded => l.addBikeApiLimit,
        RcLookupStatus.networkError => l.addBikeNoInternet,
        _ => l.addBikeFetchFailed,
      };
    }

    if (!mounted) return;
    context.push('/onboarding/vehicle-details', extra: {
      'vehicle': vehicle,
      'prefillSuccess': prefillSuccess,
      'failureReason': failureReason,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // Icon badge
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: const Icon(
                  Icons.two_wheeler_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text(
                l.addBikeTitle,
                style: AppTextStyles.heading1.copyWith(color: textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.addBikeSubtitle,
                style: AppTextStyles.body.copyWith(color: textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Section label
              Text(
                l.fieldRegNumber.toUpperCase(),
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Large RC input
              TextField(
                controller: _rcCtrl,
                enabled: !_fetching,
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text
                        .replaceAll(RegExp(r'[\s\-]'), '')
                        .toUpperCase();
                    return TextEditingValue(
                      text: text,
                      selection:
                          TextSelection.collapsed(offset: text.length),
                    );
                  }),
                ],
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'MH12DE1234',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: textTertiary,
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _rcCtrl,
                    builder: (_, value, _) => value.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded,
                                size: 20, color: textSecondary),
                            onPressed: () {
                              _rcCtrl.clear();
                              setState(() => _error = null);
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                  errorText: _error,
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                onSubmitted: (_) {
                  if (!_fetching) _continue();
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              Text(
                l.addBikeExamples,
                style: AppTextStyles.caption.copyWith(color: textTertiary),
              ),

              const Spacer(),

              // CTA — replaced with loading pill while fetching
              AnimatedSwitcher(
                duration: AppDuration.normal,
                child: _fetching
                    ? _LoadingPill(key: const ValueKey('pill'), isDark: isDark)
                    : PrimaryButton(
                        key: const ValueKey('btn'),
                        label: l.addBikeContinue,
                        onPressed: _continue,
                      ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading pill — shown in place of the CTA while the API call is in flight
// ---------------------------------------------------------------------------
class _LoadingPill extends StatelessWidget {
  final bool isDark;
  const _LoadingPill({super.key, required this.isDark});

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
            context.l10n.addBikeFetching,
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
